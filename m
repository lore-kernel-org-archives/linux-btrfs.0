Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:44003 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaLSRAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:00:06 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so13285091obc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 09:00:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141219134810.GH27601@twin.jikos.cz>
References: <4A7D957D-FE36-452D-B6DB-12117FF75AB9@gmail.com>
	<719D86DC-BC2F-4A9C-9D17-F90AFFF3FFC2@gmail.com>
	<5493C450.8060204@cn.fujitsu.com>
	<20141219134810.GH27601@twin.jikos.cz>
Date: Fri, 19 Dec 2014 17:00:06 +0000
Message-ID: <CALOYprWtWrfy4K7MMuF-j+VCA6_HzkD1GEp6Z+u7tJhLDWFojw@mail.gmail.com>
Subject: Re: btrfs-progs: integration-20141218 possible corruption test regression
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 December 2014 at 13:48, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Dec 19, 2014 at 02:23:12PM +0800, Qu Wenruo wrote:
>> In fact, it's not a regression.
>>
>> The 013 testcase is a special case that uses a script to corrupt the
>> image and then do the btrfsck test.
>>
>> There is a patch before the commit, to allow btrfs-progs test script
>> call corruption script.
>> But since there is still some discussion about the corruption script and
>> maybe later verify script,
>> the previous patch is not picked.
>
> Yes, I'm waiting for final version of the patch, but wanted to add all
> test images that were available.

Thanks for the clarification, Qu, David. I've disabled test 013 in my
local builds for the mean time.
