Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760746Ab2JaVHG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 17:07:06 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1251532pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 14:07:06 -0700 (PDT)
Message-ID: <509192F7.5040807@gmail.com>
Date: Thu, 01 Nov 2012 05:07:03 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: cwillu <cwillu@cwillu.com>, Felix Pepinghege <postfach@pepinghege.net>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com> <508FC26A.1010206@pepinghege.net> <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com> <50904949.8010603@gmail.com> <20121030221412.GB11422@carfax.org.uk> <20121030221947.GC11422@carfax.org.uk> <50906702.1010608@gmail.com> <20121031001203.GD3102@twin.jikos.cz>
In-Reply-To: <20121031001203.GD3102@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 08:12 AM, David Sterba wrote:
> On Wed, Oct 31, 2012 at 07:47:14AM +0800, ching wrote:
>> On 10/31/2012 06:19 AM, Hugo Mills wrote:
>>> On Tue, Oct 30, 2012 at 10:14:12PM +0000, Hugo Mills wrote:
>>>>> if i have 10G small files in total, then it will consume 20G by default.
>>>>    If those small files are each 128 bytes in size, then you have
>>>> approximately 80 million of them, and they'd take up 80 million pages,
>>>> or 320 GiB of total disk space.
>>>    Sorry, to make that clear -- I meant if they were stored in Data.
>>> If they're inlined in metadata, then they'll take approximately 20 GiB
>>> as you claim, which is a lot less than the 320 GiB they'd be if
>>> they're not.
>>>
>> is it the same for:
>> 1. 3k per file with leaf size=4K
>> 2. 60k per file with leaf size=64k
> The inline limit is minimum of
> * 'max_inline' (8k by default)
> * PAGE_SIZE
> * leafsize - header
>
> so 60k files for 64k leaves will not get inlined, unless you have a
> system with 64k pages.
>

thank you very much for your clear explanation :)

this is the first time i heard about this.

ching
