Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FAEC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D06092086D
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="X14Qc4jR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbfBSA2f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 19:28:35 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21414 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732183AbfBSA2f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 19:28:35 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550536110; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=P97/+eLSGCAS9S8Nwugq/JO4VBK+vOJ4amh1HR7B51FkSxVV1bRZDShhf9TIRNQ7N2ybo+7dRUOaIsiE7oj9Y+nraktcFU20HBSBZSYJiG7ghL7nFoW2VKfChH0TLKhAUvmx5LFkzRP1sD4cG3cq3dBLTraUwAng+JHCPasCS5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550536110; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=TBgOb7UeF+jsRq/cTBNwMwgBsMDFySeI6XMYeYUScgE=; 
        b=Ky50J8uQ5d/BwGFYXunyTJMlUsqp5C6CTyIo48d22aM51KMVw/8K81uSMUYUnq+HMf67YScXz2Qcy4Ai2PJFdcDnvhRMCTk0szMD33Vjbo0kFxVsAOQ4MH0n1+M2yxTGCigp03rBJB41jYp44iRPAhoEcy8rKwZuGSNL176//9U=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550536110;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=3549; bh=TBgOb7UeF+jsRq/cTBNwMwgBsMDFySeI6XMYeYUScgE=;
        b=X14Qc4jR5vlkY04AyMmK0MYDEooj+xs6OYkPvTqBNPoLg3OfLsan3j2/YJd0TyNd
        yCImuSWeei/h47z+equXd5rHuH8RSTDemHpRTL3lBhZUfmR5x81mSN5j9eyBvuhFNXz
        uNoSqa8AURfzkvDFxUr6zryjkClh324bmwih1EUw=
Received: from [192.168.0.4] (c83-248-74-133.bredband.comhem.se [83.248.74.133]) by mx.zoho.eu
        with SMTPS id 1550536108760857.0409694351324; Tue, 19 Feb 2019 01:28:28 +0100 (CET)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
 <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org>
 <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org>
 <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org>
 <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
 <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org>
 <CAJCQCtRvxpai3Cs+588T+QjYJbJSs2NE=nzkZ90FY41M9peXog@mail.gmail.com>
 <fec70b89-90ee-20b9-d47a-ae1be31361fc@sheepa.org>
 <CAJCQCtSc=T=Umg4bz2M6o1bZin7Y967827Jrfkeh=nCPLy6dGQ@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <c1fc8b54-9cf6-f191-57ba-7621edefd139@sheepa.org>
Date:   Tue, 19 Feb 2019 01:28:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSc=T=Umg4bz2M6o1bZin7Y967827Jrfkeh=nCPLy6dGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Rsync is probably i bad idea yes. I could btrfs send -p the changed=20
"new" master subvolume and then delete the old master subvolume and then=20
reference the new master subvolume when transferring it later on i guess?

I'll explain the problem I'm trying to solve abit better;

Say i have a program that will run in multiple instances. The program=20
requires a dataset of large files to run (say 20GB). The dataset will be=20
updated over time, i.e parts of them changes. These changes should only=20
apply to new instances for the program. The program will also generate=20
new data (both new files and also changing data in the the shared=20
dataset) that is unique to the instance of the child subvolume. Finally=20
I need to transfer the program together with its generated data to=20
another remote machine to continue it's processing there. What i want to=20
achieve is avoid having to transfer the entire dataset when only small=20
parts of it is changed by the program. I also want to avoid having to=20
duplicate copies of the data on the remote machine.

On 2019-02-19 01:16, Chris Murphy wrote:
> On Mon, Feb 18, 2019 at 4:58 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>> I assume i would have to use rsync (with --inplace possibly) to keep the
>> master volume in sync between machines?
> Why?
>
> You previously said you didn't want to do that:
> " if I change / remove, say 10 GB worth of data from the
> master subvolume unrelated to the child subvolume I don't want those
> gigabytes sent down the wire with btrfs send as they are unrelated. "
>
> So instead of sending those changes with send you're going to send the
> changes with rsync which is even more inefficient?
>
>> Say for example I have a (large) file on master, on machine A, I cp
>> reflink it to a child subvolume. I then send -p child subvolume to
>> remote machine B (which already have the master volume).
> 1. The master snapshots must be identical snapshots on source and
> destination; it must have been replicated using send/receive or
> receive will complain.
> 2. I don't know what "send -p child subvolume to remove" means because
> -p option means two snapshots must be included and I don't know what
> two snapshots you're planning on using, so I can't answer the
> question.
>
>> Then i change
>> parts of the file on the master of machine A. I then rsync (?) the
>> master volume so its the same across the machines. Can I then later send
>> -p the child volume, either back to the original machine (A) or to a 3rd
>> machine (C) given that the master volumes are synced?
> rsync'd subvolumes across volumes aren't consistent identical by btrfs
> receive. I expect they can't be used for incremental send/receive.
> What you're trying to achieve, big picture, isn't clear. You're
> describing it in terms of send/receive and confusing it with rsync. I
> don't understand what rsync has to do with this.
>
> You realize if you merely move a large file within a subvolume, and
> then you using rsync to a remote system, it will delete the original
> file and then sync over the nework that same data to the new location?
> Rsync has no idea how to just move files around. Btrfs send-receive
> does.
>
>> About the efficiency I'm not planning to remove large amounts of data
>> that is used by child subvolumes (although some will be updated). But
>> given the unpredictability of what files will be used by child
>> subvolumes i might remove large unused amounts of data.
> OK?
>
>


