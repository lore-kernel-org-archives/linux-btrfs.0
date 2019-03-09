Return-Path: <SRS0=Falb=RM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65FEC43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 06:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885FB2081B
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 06:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfCIGdD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Mar 2019 01:33:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:55564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfCIGdD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Mar 2019 01:33:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1E3A0ACBD;
        Sat,  9 Mar 2019 06:33:01 +0000 (UTC)
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
 <20190307140223.GH31119@twin.jikos.cz>
 <ccf67c41-752a-6812-0de7-34f39c37ecac@gmx.com>
 <20190307161203.GJ31119@twin.jikos.cz>
 <4040a77a-7e64-9667-3ede-d0750456c9f4@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <7d13f8ab-06e6-6a03-04e6-dd101f08d612@suse.de>
Date:   Sat, 9 Mar 2019 14:32:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <4040a77a-7e64-9667-3ede-d0750456c9f4@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/9 下午2:21, Nikolay Borisov wrote:
> 
> 
> On 7.03.19 г. 18:12 ч., David Sterba wrote:
>> On Thu, Mar 07, 2019 at 10:18:49PM +0800, Qu Wenruo wrote:
>>>> Well, most of that is answered by 'figure out how to use tracepoints and
>>>> perf for that'.
>>>>
>>>> If there were not a whole substystem, actively maintained and
>>>> documented, implementing something like that might help, but that's not
>>>> the case.
>>>>
>>>> I see what you were able to understand from the results, but it's more
>>>> like a custom analysis tool that should not merged as-is. It brings a
>>>> whole new interface and that's always hard to get right with all the
>>>> mistakes ahead that somebody has probably solved already.
>>>>
>>>> It would be good to have list of the limitations of perf you see, and we
>>>> can find a solution ourselves or ask elsewhere.
>>>
>>> Add linux-perf-users mail list.
>>>
>>> I should mention the problem of ftrace (or my perf skill) in cover letter.
>>>
>>> The biggest problem is the conflicts between detailed function execution
>>> duration and classification.
>>>
>>> For tree lock case, indeed we can use function graph to get execution
>>> duration of btrfs_tree_read_lock() and btrfs_tree_lock().
>>> But that's all. We can't really do much classification.
>>>
>>> If just use trace event, with trace event added, then we can't get the
>>> execution duration.
>>
>> I think you can save the start and end times and put the delta to the
>> tracepoint output.
>>
> 
> Yes, this can be done and in fact JBD2 uses a similar approach. For
> example check how journal->j_stats is being used in fs/jbd2/commit.c.
> I.e stats are accumulated in a structure which is then printed by some
> tracepoints.

The idea to use the trace events other than re-inventing a sysfs
interface indeed makes sense.
I'll go traditional trace events way.

Then my question is, there is no way to make the trace events happen at
certain time point. The example in jdb2 can only be triggered by
jdb2_journal_commit_transaction().

IMHO for such accumulated accounting, it would be much more useful to
get such stats at users' will.
So we still need a method to trigger trace event at users' will.

Thanks,
Qu

> Concretely, rs_request_delayd calculates the delay between
> transaction commit being requested and the transaction entering locked
> (committing) state.
> 
