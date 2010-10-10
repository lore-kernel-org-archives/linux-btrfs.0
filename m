From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: revisiting "Hard link across subvolumes"
Date: Sun, 10 Oct 2010 21:53:59 +0200
Message-ID: <4CB219D7.4080908@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>> The link across subvolumes is not allowable.  In the beginning it was
>> possible, but that was source of bugs. See the thread "Hard link across
>> subvolumes"
>>
>> http://www.mail-archive.com/linux-btrfs <at> vger.kernel.org/msg03286.html

Similar for cp --reflink across subvolumes - also won't work.

If btrfs is to support deduplication one day, it has to work across 
subvolumes - otherwise, it won't be very useful.


-- 
Tomasz Chmielewski
http://wpkg.org

