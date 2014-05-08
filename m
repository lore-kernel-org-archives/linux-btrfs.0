Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35095 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaEHP6g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 11:58:36 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WiQiQ-0001qU-Mw
	for linux-btrfs@vger.kernel.org; Thu, 08 May 2014 15:58:35 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WiQiQ-0002r7-5A
	for linux-btrfs@vger.kernel.org; Thu, 08 May 2014 16:58:34 +0100
Date: Thu, 8 May 2014 16:58:34 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Thoughts on RAID nomenclature
Message-ID: <20140508155834.GA29043@carfax.org.uk>
References: <20140505211738.GS24298@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <20140505211738.GS24298@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2014 at 10:17:38PM +0100, Hugo Mills wrote:
>    A passing remark I made on this list a day or two ago set me to
> thinking. You may all want to hide behind your desks or in a similar
> safe place away from the danger zone (say, Vladivostok) at this
> point...
> 
>    If we switch to the NcMsPp notation for replication, that
> comfortably describes most of the plausible replication methods, and
> I'm happy with that. But, there's a wart in the previous proposition,
> which is putting "d" for 2cd to indicate that there's a DUP where
> replicated chunks can go on the same device. This was the jumping-off
> point to consider chunk allocation strategies in general.
> 
>    At the moment, we have two chunk allocation strategies: "dup" and
> "spread" (for want of a better word; not to be confused with the
> ssd_spread mount option, which is a whole different kettle of
> borscht). The dup allocation strategy is currently only available for
> 2c replication, and only on single-device filesystems. When a
> filesystem with dup allocation has a second device added to it, it's
> automatically upgraded to spread.
> 
>    The general operation of the chunk allocator is that it's asked for
> locations for n chunks for a block group, and makes a decision about
> where those chunks go. In the case of spread, it sorts the devices in
> decreasing order of unchunked space, and allocates the n chunks in
> that order. For dup, it allocates both chunks on the same device (or,
> generalising, may allocate the chunks on the same device if it has
> to).
> 
>    Now, there are other variations we could consider. For example:
> 
>  - linear, which allocates on the n smallest-numbered devices with
>    free space. This goes halfway towards some people's goal of
>    minimising the file fragments damaged in a device failure on a 1c
>    FS (again, see (*)). [There's an open question on this one about
>    what happens when holes open up through, say, a balance.]
> 
>  - grouped, which allows the administrator to assign groups to the
>    devices, and allocates each chunk from a different group. [There's
>    a variation here -- we could look instead at ensuring that
>    different _copies_ go in different groups.]
> 
>    Given these four (spread, dup, linear, grouped), I think it's
> fairly obvious that spread is a special case of grouped, where each
> device is its own group. Then dup is the opposite of grouped (i.e. you
> must have one or the other but not both). Finally, linear is a
> modifier that changes the sort order.
> 
>    All of these options run completely independently of the actual
> replication level selected, so we could have 3c:spread,linear
> (allocates on the first three devices only, until one fills up and
> then it moves to the fourth device), or 2c2s:grouped, with a device
> mapping {sda:1, sdb:1, sdc:1, sdd:2, sde:2, sdf:2} which puts
> different copies on different device controllers.

   Having thought about this some more(*), what I've described above
isn't quite right. We've got two main axes for the algorithm, and one
flag (which modifies the second axis's behaviour).

   The first axis is selection of a suitable device from a list of
candidates. I've renamed things from my last email to try to make
things clearer, but example algorithms here could be:

 - first:   The old algorithm, which simply selects the available device
            with the smallest device ID.

 - even:    The current algorithm, which selects the available device
            with the largest free space.

 - round-robin: A stateful selection, which selects the next available
            device after the last one selected.

 - forward: Like "first", only if a device becomes full, we don't go
            back to look at it until we've exhausted all the other
            devices first. This approximates a ring-buffer type
            structure (only where we only fill in gaps, obviously).

 - seq:     Like "first", only with a user-supplied arbitrary ordering of
            devices.

   These can be stateful (r-r and forward are), and each function may
be called multiple times for each block group: once per chunk
required. I don't necessarily propose to implement all of these, but
at least even and first, and possibly seq, seem sensible.

   After selecting a device on which to create a chunk, we then need
to winnow out the devices which are no longer suitable for selection
as a result of that allocation. This is the other axis, and the
behaviours here are:

 - any: The current behaviour. Only the selected device is removed
        from consideration.

 - fast, slow: Like "any", except that devices which are,
        respectively, slow and fast are put in a special "don't use"
        group which prevents them from being allocated at all.

 - grouped: All devices within the group of the selected device are
        removed from consideration. This allows us to specify, for
        example, that different copies in Nc configurations should go
        on different controllers(**). It also allows us to specify
        that metadata chunks should only go on specific devices.

 - dup: may be applied to any of the other winnowing functions, and
        simply forces that function to put its discarded devices to
        the back of the queue of possible devices again, allowing them
        to be reused.

   So, current (and strongly recommended) behaviour is even,any or
even,any+dup. The linear allocation which is sometimes requested would
be first,any -- this is the same as the old allocator from a few years
ago. Allocating different copies to different controllers might be:
even,grouped with groups A=sda,sdb,sdc;B=sdd,sde,sdf. Note that "any",
"fast" and "slow" are all special cases of "grouped". It's worth
noting, as I've just discovered, that it's possible to configure this
system to do some _really_ silly suboptimal things with chunk
allocation.

   I've got the algorithms for all this coded in python (mostly --
I've got a couple of things to finish off), to verify that it turns
into a sane implementation at least. It does.

   Hugo.

(*) Screams, sirens, sounds of breaking glass...

(**) There's a bit of a twist here to deal with RAID-10- or
RAID-50-like configurations, which is that we actually maintain two
lists for those, and allow different stripes in the same copy to share
a group, but not different copies of the same stripe. It approximately
doubles the size of the data structures we need while running an
allocation, but that's (a) transient, and (b) consists of lists of
pointers to device structures, so it's not exactly large.

> 
>    Does this all make sense? Are there any other options or features
> that we might consider for chunk allocation at this point? Having had
> a look at the chunk allocator, I think most if not all of this is
> fairly easily implementable, given a sufficiently good method of
> describing it all, which is what I'm trying to get to the bottom of in
> this discussion.
> 
>    Hugo.
> 
> (*) The missing piece here is to deal with extent allocation in a
> similar way, which would offer better odds again on the number of
> files damaged in a device-loss situation on a 1c FS. This is in
> general a much harder problem, though. The only change we have in this
> area at the moment is ssd_spread, which doesn't do very much. It also
> has the potential for really killing performance and/or file
> fragmentation.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Everything simple is false. Everything which is ---         
                          complex is unusable.                           

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2upqVheFHXiqx3kAQL3aQ/9HT7faApASGTrC179btlzvY0ShIagg11m
9sNPBJ96ZGkMA2UK6LF2c9rWLnDHTbWvgOeQn7LneMZRkKOwOvD1Ohfb3ksKjgnV
4EjIba2CsFzbnvC0hTKHzE5DDvlkBFMNkrMu6eQ0qvwJnwbwxneDWPu6EjTYWwU+
GXqlAXtf7BUz1XFC9lBC+MqFm3PDzay92oe9tUX5X2VOo/YraQ+csITJkguyooab
wOZVHXVDbmSG1+WpItD/q+ZG4LWpMhsJAsBVaVylO0buKZZb3d5eIlv+nNZqfmww
NwdQgDMq4LdMcp/uVg1Ei/zC4qRV5JuvW6i0YW+7d1eFGL9l2S+Stk2lyIUfz3pA
qbtL8o8cyBDRMEMzJTBW8JfUhaf2EWSavV38eK5Vl4kIVDbp8EQ6WLEzy/WDWB55
q7wTNbREdkMTaic/bJBcku3ufUTBtr2OpePC/6fagsc+/Mg5LjNLbymjdbFZuDem
J5xx8YJK9KKNdp6QTKXHhBYe1OqdbnazMLomCIKmHjYxrc3tuBxaZsHbUdfMwP5d
SiZophZ8Ax/22otMiTPRqiiQSckPb1dP0jh35Itn9827EuB5yYuGclvzKFbcHS9j
D6JLMj19/QoJ58GJJltwLoPZUPEXQpj0UWeVXD3bzo3g9qjCAIVUq1dodWiMOFjj
9n6EYKb5gwI=
=TUd2
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
