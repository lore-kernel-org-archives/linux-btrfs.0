From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch v3 00/23] More error handling fixes
Date: Thu, 08 Sep 2011 20:35:42 -0400
Message-ID: <4E695F5E.4070205@suse.de>
References: <20110909002240.141223014@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110909002240.141223014@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/08/2011 08:22 PM, jeffm@suse.com wrote:
> Hi all -
> 
> The following 23 patches add more error handling to the btrfs
> code:
> 
> - Add btrfs_panic - Catch locking failures in
> {set,clear}_extent_bit - Push up set_extent_bit errors to callers -
> Push up lock_extent errors to callers - Push up clear_extent_bit
> errors to callers - Push up unlock_extent errors to callers - Make
> pin_down_extent return void - Push up btrfs_pin_extent errors to
> callers - Push up non-looped btrfs_transaction_start errors to
> callers
> 
> New in this version: - Make functions with no return value return
> void (11 patches) - Simplify btrfs_submit_bio_hook - Simplify
> tree_merge_hook by adding a merge_bio helper - Push up
> submit_bio_hook failures
> 
> Changes since last submission: - Refreshed against 3.1-rc3.
> 
> -Jeff
> 


Oops. Sorry for the double-send. I had sent from a host which had
appeared to have a broken mailer. Guess it wasn't. :)

- -Jeff

- -- 
Jeff Mahoney
SuSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5pX14ACgkQLPWxlyuTD7ITdACfWxIkPTsMMlwwHdrnrccG3yd9
3mYAn1cIxuRf+w+z4ou1gkryJt1RHJ6e
=aAaR
-----END PGP SIGNATURE-----
