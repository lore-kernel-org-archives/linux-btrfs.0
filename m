Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33460 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964850AbeAXRyH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 12:54:07 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>,
        <nborisov@suse.com>
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
 <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
 <c276765c-ab66-29a9-c3d6-209ef039a8be@cs.uni-bonn.de>
 <fb757d69-add3-703f-1132-a8b97ac47d56@fb.com>
 <837ffe27-e9df-33c4-a8e8-6f7b67944eae@cs.uni-bonn.de>
From: Chris Mason <clm@fb.com>
Message-ID: <f31bcfca-8c36-ea30-c4f0-0aeb437d411d@fb.com>
Date: Wed, 24 Jan 2018 12:52:20 -0500
MIME-Version: 1.0
In-Reply-To: <837ffe27-e9df-33c4-a8e8-6f7b67944eae@cs.uni-bonn.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/22/2018 04:17 PM, Sebastian Ochmann wrote:
> Hello,
> 
> I attached to the ffmpeg-mux process for a little while and pasted the 
> result here:
> 
> https://urldefense.proofpoint.com/v2/url?u=https-3A__pastebin.com_XHaMLX8z&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=IkofqwZ_S5C0_qAXjt4EQae-mVE09Ir8zmSbuGqXaCs&s=1nw7xUkEoQF7MgYOlZ8iAA9U0UsRQObH1Z4VLqx8IF8&e= 
> 
> 
> Can you help me with interpreting this result? If you'd like me to run 
> strace with specific options, please let me know. This is a level of 
> debugging I'm not dealing with on a daily basis. :)
> 

Going to guess it's these sequences:

lseek(3, 1302012898, SEEK_SET)          = 1302012898
write(3, "\37C\266u\1\377\377\377\377\377\377\377\277\204|\271\347J\347\203\3@\0\243CY\202\0\0\0!\21"..., 262144) = 262144
write(3, "\310\22\323g7J#h\351\0\323\270\f\206\5\207(.\232\246\27\371/\376\341\0\0\200\th\3\37"..., 262144) = 262144
write(3, "\225*\245<8N\32\263\237k\331]\313\215\301\366$\7\216\0349\302AS\201\302\307T\361\365\3375"..., 262144) = 262144
write(3, "\272e\37\255\250\24n\235\341E\272Me\36'\345W\353\2337K.n\367\264\\\370\307\341_\206|"..., 262144) = 262144
write(3, "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"..., 53271) = 53271
lseek(3, 1302012902, SEEK_SET)          = 1302012902
write(3, "\1\0\0\0\0\20\320\v", 8)      = 8
lseek(3, 1303114745, SEEK_SET)          = 1303114745

It's seeking, writing, then jumping back and updating what had been written 
before.

That's going to hit the stable page writing code in btrfs that I had mentioned earlier.

At Facebook, we've been experimenting with fixes for this that are limited to O_APPEND 
slowly growing log files.  Let me think harder...

-chris
