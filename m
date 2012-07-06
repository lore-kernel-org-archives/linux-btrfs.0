Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:45088 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2GFOd4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 10:33:56 -0400
Date: Fri, 6 Jul 2012 17:33:51 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120706143350.GA10427@sli.dy.fi>
References: <4FF3032D.1010007@jan-o-sch.net>
 <20120703224756.GA21647@sli.dy.fi>
 <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
 <20120704202452.GA8996@sli.dy.fi>
 <4FF5998D.8020205@jan-o-sch.net>
 <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
In-Reply-To: <4FF6C12A.10305@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 12:42:50PM +0200, Jan Schmidt wrote:
> I've no good idea at the moment how to go on. It might help to get a feeling if
> it's shifting around at least a little bit or really constant in the timing of
> occurrence. So can you please apply the next patch on top of the other two and
> give it some more failure tries? The "checksum mismatch [1234]" line will be of
> most interest. I'm also curious what the additional debug variables will say in
> the extended version of the very first printk. You can leave out the stack
> traces if you like, they won't matter much anyway.

Ok. Also turned on CONFIG_DEBUG_PAGEALLOC and CONFIG_SLUB_DEBUG_ON as
suggested by Chris Mason.

With those and the latest patch, there's an oops already at boot. I
don't have netconsole yet at that point, but here's the important
parts (sure I can capture it fully if you need).

By the way, something seems to be untabifying your patches. I don't
know if it's on my side or yours, but at least some other patches I
receive via linux-btrfs contain tabs. Doing a M-x tabify in emacs
mostly makes them apply cleanly for me.

	Sami


------------------------------------------------------------
btrfs: disk space caching is enabled
BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
IP: [<ffffffffa0223568>] check_node+0x138/0x250 [btrfs]
PGD 0
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
CPU 6
Modules linked in: <omitted> [last unloaded: scsi_wait_scan]

Pid: 1176, comm: btrfs-endio-met Tainted: G        W     3.4.4+btrfsdebug2 #2 System Product Name/P8P67 EVO
RIP: 0010:[<ffffffffa0223568>]  [<ffffffffa0223568>] check_node+0x138/0x250 [btrfs
[...]
Process btrfs-endio-met (pid: 1176, [...])
Call trace:
 [...] btree_readpage_end_io_hook+0x1e5/0x2d0 [btrfs]
 [...] end_bio_extent_readpage+0xcb/0xa30 [btrfs]
 [...] ? end_workqueue_fn+0x31/0x50 [btrfs]
 [...] bio_endio+0x18/0x30
 [...] end_workqueue_fn+0x3c/0x50 [btrfs]
 [...] worker_loop+0x157/0x560 [btrfs]
 [...] ? btrfs_queue_worker+0x310/0x310 [btrfs]
 [...] kthead+0x8e/0xa0
 [...] kernel_thread_helper+0x4/0x10
 [...] ? flush_kthread_worker+0x70/0x70
 [...] ? gs_change+0x13/0x13
Code: [...]
RIP  [<ffffffffa0223568>] check_node+0x138/0x250 [btrfs]
 RSP <ffff8801f3843cb0>
------------------------------------------------------------

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP9vdOAAoJEKLT589SE0a06dkP/i8x/lFLesmr3PiKZIbokgCf
WRrJgwMUlIY2C0KlWfoOtlgXQzw72ToA5njERNT+Z2vziZkSy1u7OzdnR6oopsaw
wofLK+BBnK0OVxxJqrhT6Rakk0exi/dI1oWxd8n4hob3vrsCOTpfm0vq4Phi+Jnw
EsllpCqseF5IgPhxNN5Oq0R0MANIi6fA/DHsd6brOm/T9WLOwbMiIz37V/QrYKeR
iwGsQZ3vRnxo+TieRM4NkuPpm/rTdoY+RRC1pq37t6bAJmLsmsJvfEltxiuj5n3B
Gr2xuUpzMh8hhLU6AKF4zO59qWl8JNNoDkPkPkM0ooA+hgrG7mi+FZj9iJmXB50a
1J399tf+5brhT+fgWzwrWkXVKbzkaotq7O51HhoJbxoJh2nrcCZoLU+kOEP6iPfn
5JVPgj2NNk6ZlcXIP8y4B6OlmnHq5u7hosL7WX0tt0rCiUx4nFGzd77CFd+K8OeG
cFTDYv5KyedC4USty6DSHJS6TBaoKenT7osK+x2oYLUNnA6c2BzY0rnQ70NQWbyt
j1Y/OfCwwvtKWYx7SD3EnDK/YluLBOkIdsZYoXnhddCw7fUU/4AES5hsxoXbiMz3
z9j0btvR9w1486x9BN4keqpY9OTVU69KB9MUbmN2VAs1umlxZEfsB10i8FBM8nrW
tm7LG9FC4PHfaufZ4gVf
=cIjz
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
