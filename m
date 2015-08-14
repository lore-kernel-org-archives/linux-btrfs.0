Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbbHNPMF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 11:12:05 -0400
Message-ID: <55CE053F.2090805@suse.com>
Date: Fri, 14 Aug 2015 11:11:59 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: trim not working and irreparable errors from btrfsck
References: <mlpb8i$dus$1@ger.gmane.org>	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>	<55816E7B.5040905@gmail.com>	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>	<mls0gb$s7m$1@ger.gmane.org>	<CAJCQCtTJU3z4je=CBWDP6qE7_rDt46ivYBs9T1NNj3b-5Fy_PA@mail.gmail.com>	<mls4dj$2oh$1@ger.gmane.org> <5581ABA2.30906@gmail.com> <pan$e2fd3$4225d55d$123c95d2$8d29df22@cox.net>
In-Reply-To: <pan$e2fd3$4225d55d$123c95d2$8d29df22@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/18/15 1:25 AM, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 17 Jun 2015 13:17:22 -0400 as 
> excerpted:
> 
>> On 2015-06-17 11:40, Christian wrote:
>>> On 06/17/2015 11:28 AM, Chris Murphy wrote:
>>> 
>>> 
>>>>> However, fstrim still gives me "0 B (0 bytes) trimmed, so
>>>>> that may be another problem. Is there a way to check if
>>>>> trim works?
>>>> 
>>>> That sounds like maybe your SSD is blacklisted for trim, is
>>>> all I can think of. So trim shouldn't be the cause of the
>>>> problem if it's being blacklisted. The recent problems appear
>>>> to be around newer SSDs that support queue trim and newer
>>>> kernels that issue queued trim. There have been some patches
>>>> related to trim to the kernel, but the existence of
>>>> blacklisting and claims of bugs in firmware make it difficult
>>>> to test and isolate.
>>>> 
>>>> http://techreport.com/news/28473/some-samsung-ssds-may-suffer-from-
a-
>
>>>> 
buggy-trim-implementation
>>>> 
>>>> 
>>> This is an Intel SSD in a Lenovo Thinkpad X1 Carbon. Trim
>>> worked until a few weeks ago and still works for my small ext4
>>> boot partition (just ran it to check). I will keep looking for
>>> a solution. Thanks!
>>> 
>> I'm seeing the same issue here, but with a Crucial brand SSD.
>> Somewhat interestingly, I don't see any issues like this with
>> BTRFS on top of LVM's thin-provisioning volumes, or with any
>> other filesystems, so I think it has something to do with how
>> BTRFS is reporting unused space or how it is submitting the
>> discard requests.
> 
> FWIW, there's a current btrfs patch in progress that relates to
> problems with btrfs trim.
> 
> But while I do have SSDs, I purposefully overprovisioned them by
> nearly 100% (IOW I partitioned only about 55%, the rest is entirely
> unused), so trim isn't as critical here as it is for many.  I don't
> use the discard mount option, and have a systemd timer job setup to
> automate my fstrims and don't worry about the output too much, so I
> haven't been following the patch progress /that/ closely.
> 
> But I do know that recent kernel btrfs trims (either fstrim or
> discard mount option triggered) haven't been working as originally
> intended due to some bug, and this patch is supposed to fix it.
> 
> I'd thus conclude that you're very likely hitting this known issue,
> and that either for 4.1 or 4.2 (again, I'm not following progress
> that closely, and don't remember for sure if it's in 4.1, altho
> I've been running the rcs since rc6 or so), the problem should be
> fixed as that patch gets into mainline.
> 
> Anyone wishing to investigate further can of course check the list
> (and/ or possibly the kernel's git log) for discard/trim related
> patches and follow the progress once found.
> 
> ... Actually, just checked myself.  Looks like the patches were
> first posted on March 30 @ 15:12:17 -0400 or so (that's the time
> for one of them).  There's one for the discard mount option, and
> another for FITRIM (which may or may not be a typo for FSTRIM, I'm
> not actually sure).  Jeff Mahoney <jeffm@suse.com> author.  That
> should be enough to find the threads.  And I don't see the patches
> in the late 4.1-rc I'm running so either my git log search foo is
> bad or it'll be (at least) 4.2.

It's not a typo. FITRIM is the name of the ioctl that fstrim calls.

The final version of that patch set is ready to go.  Mostly.  It
probably needs to be re-integrated now.  The reason it was delayed for
inclusion is that it makes other bugs more obvious and irrecoverable
since the data is completely gone.

I'm not sure what Chris's timeline for inclusion is.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVzgU/AAoJEB57S2MheeWyjSwQALOLfzNLiuAdxBXDnP076Pq7
8m2F2DtTRxuDCwBmnlgZtX3QuWK/J1HVRpAO/aC6WQkOo3uRNFrG4xK45EOTA5hH
VBNtAFooMreicFQq5ZE6i+4yEdV8D4YRSoVn7+GrjL40IjiP8u7HXtDGw0x4ugGI
iVNf3yipaTZtlRcjGt91dfW3w3D8RpjUK3z7RwSOEy3C8GP90omRWVkYV/jcFIo4
hqFMZ77hisRLf1aCFxXlO14ERyMpLPtC3HOBMLHRrdpjPp/f4XnXyFmFA0kbOX8S
dwS9qPRmlnS5Lif2XMXK0a6aA0HK7sN/ghMigAh9t4zHwDkuDpAd6OWVEuCMMpCY
uN2KyuNsjam2DxJHQVulNu1xlS/sGedfh8p66lC29fkB8ZpyGp4fnK1N4MVRdk8R
4o/emRb+vg7CTZ3fvss7Af6w+m22GISO43Q1MWr6Hr1Ll2y0DWL1IaB/zky8sr/5
u6E5RI7DOvbFyC31dGqvh5WQDIPrTxRoDMJL+pSOkF4CM5SM1uHak4IgUqfZ85hr
MXVhRHFmH9UXRTFrkxzAV2wmSNpl2ki2pX5ItB6+c4fMMStb5dynThv27R69xxHf
mn8qZBuwc5iXXsPJ9dUAxTRoquOw9Rd/1fz4S/oLH6xOrtlNlLa2HFour4Ofp16h
3e6CvcV+h4/sz0PYpYSQ
=ZiEh
-----END PGP SIGNATURE-----
