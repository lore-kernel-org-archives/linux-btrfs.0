Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbbKZPLD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 10:11:03 -0500
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz> <565424B8.3020502@cn.fujitsu.com>
 <20151125124235.GO31035@suse.cz> <5656547F.5050900@cn.fujitsu.com>
 <20151126093028.GP31035@suse.cz> <5656DB29.2030708@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <56572102.8090001@suse.com>
Date: Thu, 26 Nov 2015 10:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <5656DB29.2030708@gmx.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 11/26/15 5:12 AM, Qu Wenruo wrote:
> 
> 
> On 11/26/2015 05:30 PM, David Sterba wrote:
>> On Thu, Nov 26, 2015 at 08:38:23AM +0800, Qu Wenruo wrote:
>>>> As far as the conversion support stays, it's not a problem of
>>>> course. I don't have a complete picture of all the actual
>>>> merging conflicts, but the idea is to provide the callback
>>>> abstraction v2 to allow ext2 and reiser plus allow all the
>>>> changes of this pathcset.
>>>> 
>>> Glad to hear that.
>>> 
>>> BTW, which reiserfs progs headers are you using?
>> 
>> Sorry I forgot to mention it, it's the latest git version, 
>> https://git.kernel.org/cgit/linux/kernel/git/jeffm/reiserfsprogs.git/
>>
>>
>> 
Jeff hasn't released v3.6.25 yet. We have the git version in SUSE
>> distros so it works for me here. -- To unsubscribe from this
>> list: send the line "unsubscribe linux-btrfs" in the body of a
>> message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>> 
> Thanks, now it should be OK to continue the rebase.
> 
> But I'm a little concerned about the unstable headers, unlike ext2
> its headers is almost stable but reiserfs seems not.

This is entirely due to the fact that splitting out library
functionality for reiserfsprogs was only done to support
btrfs-convert.  Unless there's some pressing need to revise the API,
the headers are pretty much static at this point.

I should just go ahead and release the current snapshot as 3.6.25.
Today's a US holiday and I won't be able to get to it, but I'll do
that in the next few days.

- -Jeff

> What about rebasing my patch to your abstract patch (btrfs-progs: 
> convert: add context and operations struct to allow different file 
> systems) first and add back your reiserfs patch?
> 
> Your abstract patch is quite nice, although need some modification
> to work with new convert. I hope to add stable things first and
> don't want another reiserfs change breaks the compile.
> 
> Thanks, Qu
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJWVyECAAoJEB57S2MheeWyHFQP/jNSZthnme+Gr6HV9DcGNuWb
F3m4HOauGny+5mWzWjzATcS6YjAB0Hr0ObXi6jgoQxueBTInZKfgRYIqF6q1hdxS
NymluoAi9lkTkgkiCTZWmUexUaGE2pDzWR14dzqkBorqfCkvyvBVrkXV32FQUJ9H
ln85QND805HUiHol3+rqSSFhxN8A8C+3UMkxOuUCrlkBx8KkzdKVrFJNH4+2L3Ml
tt1KYkWa4hCOYqFivzxDJ69HWNBkUIPXsig+38Lw/JkuLbt82DfMAVu5QbttAgus
1/ZOhPwv7grRfV/CpCpNHPV/AvLLLR0wu5DNCej4HsC81WH4KUE5Isavk2WxQAF3
gpFdnxh2Ok3n+g/obFpDKh43XjVIbtRel4bsB13WjfM9mUNFX8lm/vnK8bjmuoGo
FRf0eQwY3YZAzFrTglFBQxK4eUnopDr1CTFTmnLtBoYKSojDdwe8KQTDWuimLyXb
/BY7qeiW3Cahm+V2VrL76cnbxg5/xH0u6CKrfsg9p4NpP9+5bi72vLgy16IJI+a2
jf6pLvgOi9MwMGW42tIHGna+vFwPAaoL4Iqm4qbWqHZ/R91bNAfWgOdBEubqHuYi
qML5RAttojrw7ZtwSLkBxnOyj3ias3c2jDTQ1yqaSVMJ6phn9XwzB5v4I87qEdsS
a8QhP69u++S+PcohdSYQ
=3s6k
-----END PGP SIGNATURE-----
