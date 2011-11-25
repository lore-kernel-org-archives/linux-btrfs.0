From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 01/99] btrfs: Add btrfs_panic()
Date: Thu, 24 Nov 2011 21:36:55 -0500
Message-ID: <4ECEFF47.9090006@suse.com>
References: <20111124003533.395674389@suse.com> <20111124004219.933819241@suse.com> <20111124020533.GA14982@davidb.org> <4ECDAA4E.9000201@suse.com> <20111124063722.GB15023@davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: David Brown <davidb@davidb.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124063722.GB15023@davidb.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2011 01:37 AM, David Brown wrote:
> On Wed, Nov 23, 2011 at 09:22:06PM -0500, Jeff Mahoney wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 11/23/2011 09:05 PM, David Brown wrote:
>>> On Wed, Nov 23, 2011 at 07:35:34PM -0500, Jeff Mahoney wrote:
>>>> As part of the effort to eliminate BUG_ON as an error
>>>> handling technique, we need to determine which errors are
>>>> actual logic errors, which are on-disk corruption, and which
>>>> are normal runtime errors e.g. -ENOMEM.
>>>> 
>>>> Annotating these error cases is helpful to understand and
>>>> report them.
>>>> 
>>>> This patch adds a btrfs_panic() routine that will either
>>>> panic or BUG depending on the new -ofatal_errors={panic,bug}
>>>> mount option. Since there are still so many BUG_ONs, it
>>>> defaults to BUG for now but I expect that to change once the
>>>> error handling effort has made significant progress.
>>> 
>>> Any reason all of the commit text is indented in this series?
>> 
>> Our internal patches have a bunch of RFC822-style headers
>> associated with them. For me, indenting the body is a style
>> thing. I like having the body appear separate from the headers.
> 
> Probably best not to, it makes them inconsistent with the rest of
> the kernel's history when imported into git.  The body becomes the
> commit text directly.

I'll change them to do this since you're obviously correct. You're the
first person in 10+ years to notice (or at least comment on) it,
though. ;)

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzv9HAAoJEB57S2MheeWyTgsP+wUEW1gJkxyvuVymaL2qTXkz
ZFDzEIjzmb5x3/jt48yx+iD6ElshVUGYAimoeNkurBVPpi4lJ0n9ydpNm67To/cx
K9u2/5ld0/Ua+s8uTXjBxDQG/WSOPRk8pc3Y4gIIWyDn+dYQAUb5SvDc6/qWS0BS
aQT0faX1FO3g+Hp6ZbLbYgXa/5rqrm0L9Ek13f7bq6T8l3wzDlsgWnS8KtYhwnpr
4rPAU5eythJYj9OGMB34/YoOeDs61tJbbvvNW6TysdiEEdzqf6UQ1EF61r9G41aW
wXsA4f8oSYsM2t97eH5fGrk+0j2sXPf6CoxIG73DU51L3X4htY4fPc1SQyz0SwSR
t7CKt+ffT/oa9nCXuHsfwXZBCpDdIRFiVXgibL/rBX9akWXt61W9jZnZXISOU3QZ
kTOl9VaNAKCWfOMDbKq40cKbYANE16zQ37aXaWMilagsVHCkJH47HJJ17h0IlFqy
n+zu7++/iPYwclVxCEs/bUr4XyCxSDrqRsUM8s68u7BoZP3EWrmhtMmH11XXkg8e
iznttk4/lU8Chg0+yoS03tOQquOa3+y7rYgbq9r2h35f2tv1N+s4me8iO+hSJXwO
0vS7Akvf9n8583jd/y8F3UTl1G7obKAN7ooNURewHo0AzsmNVkK9FyK9SY07I1eS
w/Zu4uB9dQPxCqM5I5fm
=ZhyI
-----END PGP SIGNATURE-----
