Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36748 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaEHVzM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 17:55:12 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WiWHV-0004Dc-46
	for linux-btrfs@vger.kernel.org; Thu, 08 May 2014 21:55:10 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WiWHU-0005fp-HA
	for linux-btrfs@vger.kernel.org; Thu, 08 May 2014 22:55:08 +0100
Date: Thu, 8 May 2014 22:55:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Thoughts on RAID nomenclature
Message-ID: <20140508215508.GA16185@carfax.org.uk>
References: <20140505211738.GS24298@carfax.org.uk>
 <20140508155834.GA29043@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
In-Reply-To: <20140508155834.GA29043@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 04:58:34PM +0100, Hugo Mills wrote:
>    The first axis is selection of a suitable device from a list of
> candidates. I've renamed things from my last email to try to make
> things clearer, but example algorithms here could be:
> 
>  - first:   The old algorithm, which simply selects the available device
>             with the smallest device ID.
> 
>  - even:    The current algorithm, which selects the available device
>             with the largest free space.
> 
>  - round-robin: A stateful selection, which selects the next available
>             device after the last one selected.
> 
>  - forward: Like "first", only if a device becomes full, we don't go
>             back to look at it until we've exhausted all the other
>             devices first. This approximates a ring-buffer type
>             structure (only where we only fill in gaps, obviously).
> 
>  - seq:     Like "first", only with a user-supplied arbitrary ordering of
>             devices.
> 
>    These can be stateful (r-r and forward are), and each function may
> be called multiple times for each block group: once per chunk
> required. I don't necessarily propose to implement all of these, but
> at least even and first, and possibly seq, seem sensible.
> 
>    After selecting a device on which to create a chunk, we then need
> to winnow out the devices which are no longer suitable for selection
> as a result of that allocation. This is the other axis, and the
> behaviours here are:
> 
>  - any: The current behaviour. Only the selected device is removed
>         from consideration.
> 
>  - fast, slow: Like "any", except that devices which are,
>         respectively, slow and fast are put in a special "don't use"
>         group which prevents them from being allocated at all.
> 
>  - grouped: All devices within the group of the selected device are
>         removed from consideration. This allows us to specify, for
>         example, that different copies in Nc configurations should go
>         on different controllers(**). It also allows us to specify
>         that metadata chunks should only go on specific devices.
> 
>  - dup: may be applied to any of the other winnowing functions, and
>         simply forces that function to put its discarded devices to
>         the back of the queue of possible devices again, allowing them
>         to be reused.
> 
>    So, current (and strongly recommended) behaviour is even,any or
> even,any+dup. The linear allocation which is sometimes requested would
> be first,any -- this is the same as the old allocator from a few years
> ago. Allocating different copies to different controllers might be:
> even,grouped with groups A=sda,sdb,sdc;B=sdd,sde,sdf. Note that "any",
> "fast" and "slow" are all special cases of "grouped". It's worth
> noting, as I've just discovered, that it's possible to configure this
> system to do some _really_ silly suboptimal things with chunk
> allocation.
> 
>    I've got the algorithms for all this coded in python (mostly --
> I've got a couple of things to finish off), to verify that it turns
> into a sane implementation at least. It does.

   ... and here's the code. Usage:

alloc <repl> <allocator> [groups] <dev_size> ...

   Examples:

$ ./alloc 2c even 1000 1000 2000             # Current behaviour RAID-1
$ ./alloc 2c even,any,dup 1000 1000 2000     # Current behaviour DUP
$ ./alloc 2cMs first 100 100 100 200 200     # RAID-10, first-found allocator
$ ./alloc 1c3s1p rr,grouped A=0,1:B=2,3 100 100 100 100

   Allocators are {even,forward,first,rr},{any,grouped},{distinct,dup}.

   If "grouped" is selected, you must supply a group mapping:
<groupid>=<dev>,<dev>,...:<groupid>=<dev>,<dev>,...:... A <groupid> of
"." prevents use of that group entirely.

   Device sizes are scaled to a maximum of 24, for display purposes.

   Hugo.

#!/usr/bin/python3

import sys
import itertools

# Device list filters: filter the sequence of eligible devices based
# on the selected device. Return the filtered sequence

# winn_any is the existing algorithm: it disallows a device from
# being used again if it's already been used once
def winn_any(seq, dev, dgrp, dup):
    seq.remove(dev)
    if dup:
        seq.append(dev)
    return seq

# winn_grouped uses group definitions, and disallows a device if any
# device in its group has already been used.
def winn_grouped(seq, dev, dgrp, dup):
    removed = [d for d in seq if dgrp[d.id] == dgrp[dev.id]]
    seq = [d for d in seq if dgrp[d.id] != dgrp[dev.id]]

    if dup:
        seq += removed

    return seq

# Selection algorithms: given a list of devices and a state, return a
# device (or None), and an updated state

# seq_even is the existing algorithm: pick devices with the largest
# amount of free space
def seq_even(devs, state):
    dev = None
    for d in devs:
        if dev is None or d.free > dev.free:
            dev = d

    if dev is not None:
        return dev, dev.get_first_from(0), state
    else:
        return None, 0, state

# seq_rr does a round-robin through the free devices
def seq_rr(devs, state):
    if state is None:
        state = -1
    dev = None
    for d in devs:
        # We pick a device in preference if: We don't have one at all,
        # or we've got something closer to the last selection than we
        # have at the moment (where "closer" is smaller.
        if (dev is None
            or (state < d.id and d.id < dev.id)
            or (dev.id <= state and (d.id < dev.id or d.id > state))):
            dev = d

    if dev is not None:
        state = dev.id
        return dev, dev.get_first_from(0), state
    else:
        return None, 0, state

# This is the old allocator: We pick the first device that has free
# space
def seq_first(devs, state):
    dev = None
    if devs:
        dev = devs[0]

    if dev is not None:
        return dev, dev.get_first_from(0), state
    else:
        return None, 0, state

# seq_forward keeps track of where it had allocated on a device, and
# won't go back to fill in gaps on a device until it's reached the end
# of all the other devices first. If no chunks are freed, this is
# equivalent to seq_first
def seq_forward(devs, state):
    if state is None:
        state = [0] * len(devs)

    dev = None
    for x in range(2):
        # As with seq_first, pick the first eligible device, but ignore
        # any device which doesn't have any chunks after the last-
        # allocated one.
        for d in devs:
            first = d.get_first_from(state[d.id])
            if first is not None:
                dev = d
                break

        if dev is not None:
            break

        for d in devs:
            state[d.id] = 0

    if dev is not None:
        state[dev.id] = first
        return dev, first, state
    else:
        return None, 0, state    

def free_devs(devs):
    return len([d for d in devs if d.free > 0])

def allocate(devs, sch, name):
    chunks = count_chunks(sch, devs)
    dev = None

    # Initialise the set of devices that we wish to try: drop full
    # devices immediately as uninteresting, and ones with a group ID
    # of ".", which are forbidden in this scheme
    seq = [d for d in devs if d.free > 0 and sch.dgrp[d.id] != "."]
    # nxt is the list of devices we haven't allocated a chunk to
    nxt = seq[:]
    # rem is the list of devices already allocated: we recycle this
    # when nxt is empty if we're doing dup
    rem = []

    # Generate the sequence of chunk IDs: for each stripe component,
    # we run through all the copies in order. The chid is a 2-tuple,
    # of (data-stripe, copy)
    ids = itertools.product(range(chunks//sch.c), range(sch.c))
    c_and_s = (sch.c > 1 and chunks//sch.c > 1)

    # Now iterate through the sequence, picking devices in turn
    # and modifying the list as appropriate
    chid = (-1, -1)
    while chunks > 0:
        old = chid[0]
        chid = next(ids)
        print("  chid", chid, "old", old)

        # If we're doing multiple copies and multiple data-stripes,
        # and have skipped to the next data-stripe, we need to
        # reinitialise our list of devices with the ones that we
        # haven't used so far.
        if c_and_s and chid[0] != old:
            if sch.dup and len(nxt) == 0:
                nxt = rem
                rem = []
            seq = nxt[:]

        # Select a suitable device and location for the new chunk,
        # based on the current list of candidates and the current
        # state
        print("  Eligible device sequence is",
              " ".join((str(d.id) for d in seq)))
        print("  nxt =", nxt)
        dev, pos, sch.state = sch.sequence(seq, sch.state)

        if dev is None:
            print("  Failed -- no suitable device found")
            break

        print("  Found device", repr(dev), "at", pos, "seq", seq, "state", sch.state)
        dev.set_at(pos, name)

        # Filter the remaining candidates based on the selection
        seq = sch.winnower(seq, dev, sch.dgrp, sch.dup)
        nxt.remove(dev)

        print("  Filtered seq", seq, "/", nxt)
        chunks -= 1

    for d in devs:
        if dev is None:
            d.rollback()
        else:
            d.commit()

    return dev is not None

def count_chunks(sch, devs):
    # How many chunks do we want to allocate?
    # First, work out the total number of stripes we have to play with
    if sch.s is None:
        stripe = free_devs(devs) // sch.c
        # Complain if we drop below 1 data stripe with parity,
        if sch.p > 0 and stripe < sch.p + 1:
            return -1
        # Or 2 data stripes without
        if sch.p == 0 and stripe < 2:
            return -1
    else:
        stripe = sch.s + sch.p

    return stripe * sch.c

def all_alpha():
    return itertools.chain(range(ord("A"), ord("Z")+1),
                           range(ord("a"), ord("z")+1))

class Scheme(object):
    # This is just a dumb struct to hold all the details necessary for
    # a single scheme
    pass

def main():
    sch = Scheme()

    sys.argv.pop(0)
    # Parse input:
    sch.c, sch.s, sch.p = parse_csp(sys.argv.pop(0))
    sch.sequence, sch.winnower, sch.dup, grouped = parse_alloc(sys.argv.pop(0))
    sch.state = None
    if grouped:
        sch.dgrp = parse_groups(sys.argv.pop(0))
    else:
        sch.dgrp = [0] * len(sys.argv)

    # Device sizes
    devsz = normalise_devs([int(sz) for sz in sys.argv])
    devs = [Device(i, sz) for i, sz in enumerate(devsz)]

    for d in devs:
        print(d)
    print()

    # List of chunks to allocate
    names = itertools.chain(
        ("{0}{0}".format(chr(c)) for c in all_alpha()),
        ("{0}*".format(chr(c)) for c in all_alpha()),
        ("{0}:".format(chr(c)) for c in all_alpha()),
        ("{0}^".format(chr(c)) for c in all_alpha()),)

    success = True
    while success:
        name = next(names)
        print("Name is", name)

        success = allocate(devs, sch, name)

        for d in devs:
            print(d)
        print()


class Device(object):
    def __init__(self, i, size):
        self.id = i
        self.size = size
        self.free = size
        self.alloc = ["--" for x in range(size)]

    def get_first_from(self, pos):
        for i in range(pos, self.size):
            if self.alloc[i] == "--":
                return i
        return None

    def set_at(self, pos, name):
        self.alloc[pos] = "." + name
        self.free -= 1

    def commit(self):
        for i in range(0, self.size):
            if self.alloc[i][0] == ".":
                self.alloc[i] = self.alloc[i][1:]

    def rollback(self):
        for i in range(0, self.size):
            if self.alloc[i][0] == ".":
                self.alloc[i] = "--"

    def __str__(self):
        return "{0.id:2d} |".format(self) + " ".join(self.alloc) + "|"

    def __repr__(self):
        return "dev{0.id}".format(self)

## Parsing code and assorted infrastructure

def parse_csp(csp):
    c = "1"
    s = "1"
    p = "0"
    c, sp = csp.split("c")
    if sp != "":
        s, pp = sp.split("s")
        if pp != "":
            p, x = pp.split("p")
            if x != "":
                raise ValueError("p must be the last character in the csp string")
    c = int(c)
    if s == "M":
        s = None
    else:
        s = int(s)
    p = int(p)
    return c, s, p

WINNOWER = {"any": winn_any,
            "grouped": winn_grouped,
            }
SEQUENCE = {"even": seq_even,
            "forward": seq_forward,
            "first": seq_first,
            "round-robin": seq_rr,
            "rr": seq_rr, # Synonym for round-robin
            }
PACKING = {"distinct": "distinct",
           "dup": "dup",
           }
        
def parse_groups(s):
    gdev = {}
    maxdev = 0
    for g in s.split(":"):
        name, devlist = g.split("=")
        devs = [int(d) for d in devlist.split(",")]
        gdev[name] = devs
        maxdev = max(maxdev, *devs)
    print("Largest device ID is", maxdev)
    dgrp = [0] * (maxdev+1)
    for g, ds in gdev.items():
        for d in ds:
            dgrp[d] = g
    print(dgrp)
    return dgrp

def parse_alloc(s):
    opts = s.split(",")
    aopt = "even"
    wopt = "any"
    popt = "distinct"
    try:
        sopt = opts[0]
        wopt = opts[1]
        popt = opts[2]
    except IndexError:
        pass
    sequence = SEQUENCE[sopt]
    winnower = WINNOWER[wopt]
    packing = PACKING[popt]

    return sequence, winnower, (packing == "dup"), (wopt == "grouped")

def normalise_devs(seq):
    maxs = max(*seq)
    if maxs > 24:
        return [int(s*24/maxs+0.5) for s in seq]
    else:
        return seq

if __name__ == "__main__":
    main()


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There's an infinite number of monkeys outside who want to ---    
               talk to us about this new script for Hamlet               
                           they've worked out!                           

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2v9PFheFHXiqx3kAQKcmw/+N5A6D9Yu3fwaijrjpTKs96EdD6ab2r1/
iNW8lNpuIAV0IhCZPQg0sRyOncmvTLF/Uzyuzub0EqgILmd59mI/SEBeT3cDc77k
+WYHIQkK7In7Y9R0GvqU4hU97KXK9dSQqfHbQlEvWZM17K5YEIc8Mt306Su3CeaJ
RVrWMa1v2uhsNI6c2YXqoUBECblRRb/kFNrUVQT13FOgZ+Sarw4FWZS6VwpiKJGD
dc7730gkw+fTqCOknlJ988mc9dWO3pGYAPA4v/eXSizfhbjgC0AYLrQFiAHzAouv
jxxYEQe/BRYztwdWNwXHUTVUTFBXUR0xM3v6SH/1SPPz86qOQGfqIj5p6hpqx7+e
TkHlRbla5ST2d+WO7UM7cBE97u7B6ZMgnpCsjZSemdmUXJ2td0tdiZ3fjUH5UfcG
dsayvnMJ34xGGLi0tJtiYlT+WLpyOVBzPPF2kxTWCis1vOLE9xjudwvjCK2yzjZE
Vv64fdr5/SuEznqsY7H/wsMYBpRT/j8FIRebasD8UnBYQq7QqEgIGfJ0LoqoupZq
OkhHwyP2qbboCvDRIPewgaz3nnZK4KunN5AzcMzerCOy0L4JdHgYtgnyvgPB+AoV
FoovUYdq9wgWeeK5uZtqF49Amo7M3SjRxER3quM5dtD+r+bcZsJyQbQhk6Ser9lo
yAbs3bRlXnA=
=/791
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
