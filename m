From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 00/21] [RFC] Btrfs: restriper
Date: Wed, 16 Nov 2011 22:13:53 -0500
Message-ID: <4EC47BF1.7070308@cfl.rr.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/23/2011 04:01 PM, Ilya Dryomov wrote:
> Hello,
> 
> This patch series adds an initial implementation of restriper (it's
> a clever name for relocation framework that allows to do selective
> profile changing and selective balancing with some goodies like
> pausing/resuming and reporting progress to the user.
> 
> Profile changing is global (per-FS) so far, per-subvolume profiles 
> require some discussion and can be implemented in future.  This is
> a RFC so some features/problems are not yet implemented/resolved.
> The current TODO list is as follows:

I managed to use these patches to convert the raid1 system and
metadata chunks back to single and drop the second disk from a two
disk array.  In doing so I noticed that the restriper required a force
switch to downgrade raid1 to single.  This seems completely
unnecessary to me.  A force switch to btrfs device delete might make
sense since delete may or may not force a downgrade, but with
restripe, the request to convert from raid1 to single is already quite
explicit with no room for ambiguity, so there should be no need for an
additional confirmation switch.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7Ee+oACgkQJ4UciIs+XuIGIQCdFx9cP7cPQPslE9IcFNDg/6Ns
LQYAn2l2ykGwiJt/yZNvuqePyMj3sxYH
=P+HR
-----END PGP SIGNATURE-----
