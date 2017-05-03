Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54319 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdECLpQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 07:45:16 -0400
Date: Wed, 3 May 2017 11:45:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Ded
Message-ID: <20170503114510.GA9701@carfax.org.uk>
References: <CANT5p=prE-Vm7mGLhQNDwWiJ3k8bRbj-M-rtwk-k6j+_Ad1pBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
In-Reply-To: <CANT5p=prE-Vm7mGLhQNDwWiJ3k8bRbj-M-rtwk-k6j+_Ad1pBQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 03, 2017 at 05:11:04PM +0530, Shyam Prasad N wrote:
> Hi,
> 
> This email is actually several questions clubbed as one...
> 
> I have a btrfs filesystem mounted at /btrfs_vol/
> Every N minutes, I run bedup for deduplication of data in /btrfs_vol
> Inside /btrfs_vol, I have several subvolumes (consider this as home
> directories of several users)
> I have set individual qgroup limits for each of these subvolumes.
> Additionally, I'm using btrfs-send/receive to backup each subvolume to
> an identical btrfs filesystem on a remote server.
> 
> I hope I've explained the setup clearly. Now, here are my questions:
> 1. I understand that bedup does deduplication on whole-file basis. I
> also read that duperemove works at extent level.
> How do the two compare in terms of performance?
> How stable is duperemove? I read a few posts suggesting bugs related
> to extent-same.
> duperemove seems ideal for my workload. However, have stayed away from
> it, fearing instability.
> 
> 2. Is it possible to have nested subvolumes (like in my tree
> structure), and run btrfs-send and expect the data whole filesystem
> (including all subvolumes) to be sent?

   No, because send requires read-only snapshots, and the snapshot
operation isn't recursive. So you can't send everything in one go.

> My problem is that, since I send btrfs subvolumes, if there is any
> dedplicated data between these subvolumes, it needs to send 2 copies
> of the same data to the remote host.
> You might ask why not have just a single subvolume and backup the whole thing.
> But there are many cool features, like quotas and btrfs send/receive
> based backup for selected user home directories, which works only at
> the subvolume level.

   The solution to this problem is to use send -c repeatedly, sending
the subvolumes one at a time, with one -c option for every subvolume
that already exists on the receiving machine. So you'll do something
like this:

send snap1
send -c snap1 snap2
send -c snap1 -c snap2 snap3
send -c snap1 -c snap2 -c snap3 snap4
etc...

   Hugo.

-- 
Hugo Mills             | Gomez, darling, don't torture yourself.
hugo@... carfax.org.uk | That's my job.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Morticia Addams

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZCcLGAAoJEFheFHXiqx3k3fQP/iRa5cu34evS3FF9C+jnhZG8
GOsig5ZWDH6MhuYy7vI5yNwYqXQhW6NUe3cwCzT81mjiGZYP8y3XU9HWlduJgxTl
YSOb3mES/GS9wsAnQd/R9l9jIEHyRUvRyJGCwJq6wSxdlDBW0jXvE5pudPeoCZK9
Q5YC4TSiBTYq0Y4JG1yWLaY/SLrb2wWH5u/Ch9YQD1tGe+HLPe0OqEH8aLqAbQBa
uVkM2EzTobIjaGlieHOlwjfH597wvzRiY2euVoJWIEs9U5LFSJDLVbqTPstMXi70
jLS2vASDXjNKgAOnl0xL+tZRtcPWV5pgZi6VkjsHtMHyV+HSMybmHQcp/yWNJhAy
nVomp9phaux1loOLJ9Ht3ACGhCJgjTRSIIl+CZV8hHHX3gWQpAm2aOsCPTDqkSVu
q+cenMJgAm0F3Ipk1NIdkQDWu1hcC7PgOAV1MCEl4b6CBSWGpShh2tZpYPVU7z7F
lx4yjL0o5kG8Ti07peA6tjDlqSh17qKp1jdfYYQyL0wP0MXwE82hrI1bGxjEW4vZ
oYIOnS7GXWgsL6ST/UmY3UCwTSKGygX125cYRYF/2l2HFRTqxln6JjFIPEOlnMV/
8MhwTvFjTq4yHLrUgseymKGPcsIv/N9ES0BrWLk4E2VC1udbf2aF3cnjv8z8RDDh
6oTsPlEOrnQggB38TkCT
=2hS1
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
