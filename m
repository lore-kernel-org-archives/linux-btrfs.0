Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2J3XrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 19:47:17 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so537703pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 16:47:16 -0700 (PDT)
Message-ID: <50906702.1010608@gmail.com>
Date: Wed, 31 Oct 2012 07:47:14 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com> <508FC26A.1010206@pepinghege.net> <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com> <50904949.8010603@gmail.com> <20121030221412.GB11422@carfax.org.uk> <20121030221947.GC11422@carfax.org.uk>
In-Reply-To: <20121030221947.GC11422@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 06:19 AM, Hugo Mills wrote:
> On Tue, Oct 30, 2012 at 10:14:12PM +0000, Hugo Mills wrote:
>> On Wed, Oct 31, 2012 at 05:40:25AM +0800, ching wrote:
>>> On 10/30/2012 08:17 PM, cwillu wrote:
>>>>>> If there is a lot of small files, then the size of metadata will be
>>>>>> undesirable due to deduplication
>>>>> Yes, that is a fact, but if that really matters depends on the use-case
>>>>> (e.g., the small files to large files ratio, ...). But as btrfs is designed
>>>>> explicitly as a general purpose file system, you usually want the good
>>>>> performance instead of the better disk-usage (especially as disk space isn't
>>>>> expensive anymore).
>>>> As I understand it, in basically all cases the total storage used by
>>>> inlining will be _smaller_, as the allocation doesn't need to be
>>>> aligned to the sector size.
>>>>
>>> if i have 10G small files in total, then it will consume 20G by default.
>>    If those small files are each 128 bytes in size, then you have
>> approximately 80 million of them, and they'd take up 80 million pages,
>> or 320 GiB of total disk space.
>    Sorry, to make that clear -- I meant if they were stored in Data.
> If they're inlined in metadata, then they'll take approximately 20 GiB
> as you claim, which is a lot less than the 320 GiB they'd be if
> they're not.
>
>    Hugo.
>


is it the same for:
1. 3k per file with leaf size=4K
2. 60k per file with leaf size=64k


