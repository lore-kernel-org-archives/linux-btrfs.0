Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59519 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaG2N4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 09:56:50 -0400
Received: by mail-pa0-f52.google.com with SMTP id bj1so12433748pad.39
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 06:56:49 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs-progs: fix some build warnings on 32bit platform
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20140729134814.GT1553@twin.jikos.cz>
Date: Tue, 29 Jul 2014 21:56:46 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <9F558E7B-1384-43EA-BAE0-6F01A31E609B@gmail.com>
References: <1406393395-4317-1-git-send-email-wangshilong1991@gmail.com> <20140729134814.GT1553@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David£¬

> On Sun, Jul 27, 2014 at 12:49:55AM +0800, Wang Shilong wrote:
>> cmds-restore.c:120:4: warning: format %lu expects argument of type
>> long unsigned int, but argument 3 has type size_t [-Wformat=]
>>    fprintf(stderr, "bad compress length %lu\n", in_len);
> 
>> --- a/cmds-restore.c
>> +++ b/cmds-restore.c
>> @@ -117,7 +117,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
>> 		in_len = read_compress_length(inbuf);
>> 
>> 		if ((tot_in + LZO_LEN + in_len) > tot_len) {
>> -			fprintf(stderr, "bad compress length %lu\n", in_len);
>> +			fprintf(stderr, "bad compress length %u\n", in_len);
> 
> in_len is size_t, this prints a warning on 64bit. Let's make it %lu and
> cas to unsigned long (fixed locally, no need to resend), we'er not using
> the 'z' size_t modifier for printf anywhere.


I am sorry that i forgot to test the patch on 64bit.  As i have left current
company, i could not setup a 64 bit machine until next week.

So i will appreciate it if you could fix this when merging or wait
until next week once i got a 64bit machine.


Thanks,
Wang