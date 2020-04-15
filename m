Return-Path: <SRS0=FXaq=57=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52809C2BB1D
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Apr 2020 01:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35FA8208E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Apr 2020 01:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392498AbgDOBVM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:21:12 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:12034 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392479AbgDOBVK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Apr 2020 21:21:10 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee45e966162f67-5b220; Wed, 15 Apr 2020 09:20:34 +0800 (CST)
X-RM-TRANSID: 2ee45e966162f67-5b220
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.21.224] (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee25e9661610ba-4593e;
        Wed, 15 Apr 2020 09:20:33 +0800 (CST)
X-RM-TRANSID: 2ee25e9661610ba-4593e
Subject: Re: [PATCH] btrfs: Fix backref.c selftest compilation warning
To:     dsterba@suse.cz, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
References: <20200411154915.9408-1-tangbin@cmss.chinamobile.com>
 <20200414151931.GU5920@twin.jikos.cz> <20200414152233.GV5920@twin.jikos.cz>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <f292429f-6b4e-4b2e-db5a-9bf02a3cde0e@cmss.chinamobile.com>
Date:   Wed, 15 Apr 2020 09:22:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414152233.GV5920@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi David:

On 2020/4/14 23:22, David Sterba wrote:
> On Tue, Apr 14, 2020 at 05:19:31PM +0200, David Sterba wrote:
>> On Sat, Apr 11, 2020 at 11:49:15PM +0800, Tang Bin wrote:
>>> Fix missing braces compilation warning in the ARM
>>> compiler environment:
>>>      fs/btrfs/backref.c: In function ‘is_shared_data_backref’:
>>>      fs/btrfs/backref.c:394:9: warning: missing braces around initializer [-Wmissing-braces]
>>>        struct prelim_ref target = {0};
>>>      fs/btrfs/backref.c:394:9: warning: (near initialization for ‘target.rbnode’) [-Wmissing-braces]
>>>
>>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
>>> Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>
>>> ---
>>>   fs/btrfs/backref.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>>> index 9c380e7..0cc0257 100644
>>> --- a/fs/btrfs/backref.c
>>> +++ b/fs/btrfs/backref.c
>>> @@ -391,7 +391,7 @@ static int is_shared_data_backref(struct preftrees *preftrees, u64 bytenr)
>>>   	struct rb_node **p = &preftrees->direct.root.rb_root.rb_node;
>>>   	struct rb_node *parent = NULL;
>>>   	struct prelim_ref *ref = NULL;
>>> -	struct prelim_ref target = {0};
>>> +	struct prelim_ref target = {};
>> I wonder why this initialization is a problem while there are about 20
>> other uses of "{0}". The warning is about the embedded rbnode, but why
>> does a more recent compiler not warn about that? Is this a missing fix
>> from the one you use?
>>
>> I don't mind fixing compiler warnings as long as it bothers enough
>> people, eg. we have fixes reported by gcc 7 but I'm hesitant to fix
>> anything older without a good reason.
> This seems to be the bug report
>
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119
> "Bug 53119 - -Wmissing-braces wrongly warns about universal zero
> initializer {0} "

Thank you for your reply. My tool chain is 
"arm-linux-gnueabihf-gcc(Linaro GCC 4.9-2017.01) 4.9.4".

I was trying to do an experiment on the hardware so I compiled it and 
there was a warning. Maybe as Qu Wenruo said possible tools are old?

Thank you for your patience,

Tang Bin







