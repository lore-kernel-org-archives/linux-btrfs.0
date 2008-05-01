From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Btrfs v0.14 Released
Date: Thu, 01 May 2008 16:10:19 -0400
Message-ID: <481A23AB.1020302@suse.com>
References: <200804291601.32945.chris.mason@oracle.com> <c24352ca0805010939q31f743aev17cc7f98d2ad0c71@mail.gmail.com> <481A14BA.9090305@canonical.com> <200805011517.55698.chris.mason@oracle.com> <481A1BB9.8050109@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, jeffschroeder@computer.org,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	John Johansen <jjohansen@suse.de>
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <481A1BB9.8050109@canonical.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tim Gardner wrote:
> Chris Mason wrote:
>> On Thursday 01 May 2008, Tim Gardner wrote:
>>
>> [ btrfs oops on ubuntu ]
>>
>>>>>  This is because ubuntu kernels ship with apparmor, you'll need this
>>>>> patch:
>>>>>
>>>>>  If there is a #ifdef IM_A_UBUNTU_KERNEL I can use, I'll do it.  Jeff
>>>>> Mahoney has a similar patch for SUSE that I've been meaning to merge,
>>>>> but I wanted to lookup some way to check for ubuntu as well.
>>>>>
>>>>>  -chris
>>>>>
>>>>>  diff -r e7da2489b19b file.c
>>>>>  --- a/file.c    Wed Apr 30 13:59:35 2008 -0400
>>>>>  +++ b/file.c    Thu May 01 12:25:11 2008 -0400
>>>>>  @@ -852,7 +852,7 @@ static ssize_t btrfs_file_write(struct f
>>>>>                 goto out_nolock;
>>>>>         if (count == 0)
>>>>>                 goto out_nolock;
>>>>>  -       err = remove_suid(fdentry(file));
>>>>>  +       err = remove_suid(&file->f_path);
>>>>>         if (err)
>>>>>                 goto out_nolock;
>>>>>         file_update_time(file);
>>> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
>>> work for Hardy. However the next development kernel (Intrepid) does not
>>> have the APPARMOR patches, so just knowing that its an UBUNTU kernel is
>>> not specific enough.
>> I've been assuming the apparmor patches change remove_suid even when they are 
>> not enabled in the config.
>>
>> -chris
>>
> 
> Lets get Kees involved. He developed the patch set for Hardy. I would
> hope that if CONFIG_SECURITY_APPARMOR=n then the source would default to
> its normal state.

remove_suid() isn't the only change AppArmor makes to the VFS interface.
It's pretty invasive and requires that dentries are passed with a
companion vfsmount in most cases. Putting #ifdefs around all that code
would make the problem worse, not better.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIGiOrLPWxlyuTD7IRAh3jAKCFCrBa30G5WDwmJHI+Yb4fNAfu2QCfTUmq
Q6Sf0MVug2X0ywRcSrGi4eY=
=QwF9
-----END PGP SIGNATURE-----
