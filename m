Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417A0C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 08:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E665F20685
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 08:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aj5xN/uT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E665F20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbeJaRXr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:23:47 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38352 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbeJaRXq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 13:23:46 -0400
Received: by mail-ed1-f67.google.com with SMTP id c1-v6so12847239ede.5
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 01:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wI/8wVNLE8nEyisg/umwjM5bIuo9njNOIDsjAh/Kbhs=;
        b=aj5xN/uTlV5ebx4H3kZ6t2xwAYwkWav6ug0RJXFAGCx6JlgnEB4iPt3mD5PPf/Wmgd
         HFbCEpljFXltY90fSJA0WdqfAkKb7dyxoX64csxiBFpr2NJkcpMG18u9xyLhNEHLj4dS
         gVUoaCdFZRxhl/2z31prykndgiuhkszcHkDSKtd5+3HWVLFPDm/lXv5u7vuVkP8kzDbh
         yVeBDhabXHJfW2ArGc5UKrN44z0KYoUIPdDsravzonkMyh93rTeZ/Vchxlag5BQQ1iJn
         cYGVBSyjZiingwP94lXlhB/fyhGJ5gBwZtxfCEx+mp7thyuXScKPkvpAXGIWcZZ4gV6W
         dETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wI/8wVNLE8nEyisg/umwjM5bIuo9njNOIDsjAh/Kbhs=;
        b=KuSY804lM/R0c1TCDtDAYJcS4ncxN1eLyKral7ZNwdgBJ+yFYwV2MNVliVnczeaVWy
         2cX7lYx/GW8BV9/5bK1q2z394dOyKzH6ul7iPNpqm63l1Rw1ML2j2p6FkJYtsoxBGnGC
         iW62h6Jlu8+QNuI2SBsffknQeXqpk5zGm+egrk5GDKxjUoVusLhnmwCld6H3rZIxGX/+
         bTv5vcv1aRqiIcKFagF7mi8CXQ0zeGN6cdfBfpWnSFsoc4cO0zjbnXkTYnM+MRomKX7/
         tTqsbLb6++DtJAWsCNV8XS0zeOvMVFsaajHR+rkGn+C1+0e8SQDpGhBjC6VuTFfMbWJk
         bh4w==
X-Gm-Message-State: AGRZ1gKgprDb2cU6oIcyrrN9mhyVj1EEOiKBQCl9eSFK/phGt3Yj55dO
        vQ0fVaCOSYwiTjjtBTl/sG0BkURu
X-Google-Smtp-Source: AJdET5fH+c1PByPTY3UUwJHnlkPCVLBVxD1Y7PyJfIvjpOA+P3JrUU0ihv4+1ZYQhKFkJsOitBno9A==
X-Received: by 2002:a50:ac47:: with SMTP id w7-v6mr1183612edc.211.1540974399229;
        Wed, 31 Oct 2018 01:26:39 -0700 (PDT)
Received: from [10.20.1.223] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id n3-v6sm4642791eje.26.2018.10.31.01.26.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 01:26:38 -0700 (PDT)
Subject: Re: [PATCH] Btrfs: fix missing delayed iputs on unmount
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
 <20181031071409.GA2656@fnst.localdomain>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <6a169410-8b78-36d4-f103-bb72468a5da4@gmail.com>
Date:   Wed, 31 Oct 2018 10:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181031071409.GA2656@fnst.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 31.10.18 г. 9:14 ч., Lu Fengqi wrote:
> On Tue, Oct 30, 2018 at 05:14:42PM -0700, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> There's a race between close_ctree() and cleaner_kthread().
>> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
>> sees it set, but this is racy; the cleaner might have already checked
>> the bit and could be cleaning stuff. In particular, if it deletes unused
>> block groups, it will create delayed iputs for the free space cache
>> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
>> longer running delayed iputs after a commit. Therefore, if the cleaner
>> creates more delayed iputs after delayed iputs are run in
>> btrfs_commit_super(), we will leak inodes on unmount and get a busy
>> inode crash from the VFS.
>>
>> Fix it by parking the cleaner before we actually close anything. Then,
>> any remaining delayed iputs will always be handled in
>> btrfs_commit_super(). This also ensures that the commit in close_ctree()
>> is really the last commit, so we can get rid of the commit in
>> cleaner_kthread().
>>
>> Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> ---
>> We found this with a stress test that our containers team runs. I'm
>> wondering if this same race could have caused any other issues other
>> than this new iput thing, but I couldn't identify any.
> 
> I noticed an inode leak issue in generic/475, but whether dropping commit
> 30928e9baac2 ("btrfs: don't run delayed_iputs in commit") or applying
> this patch, the issue still exists.
> 
> I have attached the dmesg.

Are you able to trigger this reliably i.e 100% or just, say, 80-90% of
the time? If it's sporadic (but frequent) then it is likely an issue
with error handling. Also looking at the log I see:

[  367.977998] BTRFS info (device dm-3): at unmount delalloc count 8192

Meaning we are leaking 8k of delalloc space which should have been
cleaned up. And the warn is caused because we have an inode in the inode
rb tree. I will suggest that you patch btrfs_free_fs_root to print the
ino's if root->inode_tree is not empty. That way you can see if the inos
correspond to a data file or a freespace ino. But given btrfs free_fs
also complains of delaloc bytes I'd be willing to say it's data inodes.

<snip>
