Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:59335 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbbLBNxs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 08:53:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 02 Dec 2015 22:53:45 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: compression disk space saving - what are your results?
In-Reply-To: <565EEC1F.7070600@gmail.com>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <565EEC1F.7070600@gmail.com>
Message-ID: <18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-02 22:03, Austin S Hemmelgarn wrote:

>>  From these numbers (124 GB used where data size is 153 GB), it 
>> appears
>> that we save around 20% with zlib compression enabled.
>> Is 20% reasonable saving for zlib? Typically text compresses much 
>> better
>> with that algorithm, although I understand that we have several
>> limitations when applying that on a filesystem level.
> 
> This is actually an excellent question.  A couple of things to note
> before I share what I've seen:
> 1. Text compresses better with any compression algorithm.  It is by
> nature highly patterned and moderately redundant data, which is what
> benefits the most from compression.

It looks that compress=zlib does not compress very well. Following 
Duncan's suggestion, I've changed it to compress-force=zlib, and 
re-copied the data to make sure the file are compressed.

Compression ratio is much much better now (on a slightly changed data 
set):

# df -h
/dev/xvdb       200G   24G  176G  12% /var/log/remote


# du -sh /var/log/remote/
138G    /var/log/remote/


So, 138 GB files use just 24 GB on disk - nice!

However, I would still expect that compress=zlib has almost the same 
effect as compress-force=zlib, for 100% text files/logs.


Tomasz Chmielewski
http://wpkg.org

