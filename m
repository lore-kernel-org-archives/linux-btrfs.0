Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA7CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07532208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="fY0TddA2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfBSMFH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:05:07 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21415 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfBSMFG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 07:05:06 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550577903; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=OuOkps+IKeyCau8Yfsh3zqloRADzqXRnPz9E0/+jZcQ6/nv0iriIzfGl6KRkxqBQToVPVCSUPRUHBXwgMZqfNX9lhmBQOLJqOmLUZF5Z9bScS1j+ydhGUVKly1s9vQsb3vdMUVg/koIaVlhQ3ZO6NTK5Gvmm8o1Okx+/y3OWmgg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550577903; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=cOuOOP9S8SN9BZ+dx45mu0b80ErELP66drttf7uZJsY=; 
        b=iaHTEbgnsg8hXPHWcpb3C3J/8ghinr1opxWhchQnmbZRvtBBhzcL2mzfB3koJ9GoPONGSkMpBDRekl9pT83qxYx/R2StX+LqkHR9xCD4xWYkqzyFg8DfCsTXasgbj+ofmO+oDytmTU8H6yP+etjOs7zmn6ow8G8E/iRVbTBuayE=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550577903;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=2621; bh=cOuOOP9S8SN9BZ+dx45mu0b80ErELP66drttf7uZJsY=;
        b=fY0TddA2VrLx17nsGNukYUFBvTy3bXdLI9QKopPA5i+vHzgvg7oF0BZFsGZ8GRne
        0VLMjrbsM8odOVULFgc8VS3IOredH28fmY8dMkBz2LDjM2tSAj2iGu5mGFJ+laeXh4q
        hocqlZoa1kzQANzYisUjhaRHjzCguZD92/zj+p80=
Received: from [10.0.0.20] (195-198-161-213-no22.tbcn.telia.com [195.198.161.213]) by mx.zoho.eu
        with SMTPS id 1550577901880793.631023455179; Tue, 19 Feb 2019 13:05:01 +0100 (CET)
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
 <c1fc8b54-9cf6-f191-57ba-7621edefd139@sheepa.org>
 <CAJCQCtQzGCvn3DjPQUndRv=MmhVGzz5Nr=JL7p8kJim9ABmN3g@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <a2b8711b-1d6e-0ef4-ab53-d266a883d40c@sheepa.org>
Date:   Tue, 19 Feb 2019 13:05:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQzGCvn3DjPQUndRv=MmhVGzz5Nr=JL7p8kJim9ABmN3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Okay, I will indeed test the setup thoroughly. I have considered running=20
a distributed filesystem such as Ceph but my concern is that it will be=20
way to slow as disk IO speed is important. Anyways, thank you for your help=
!

On 2019-02-19 04:54, Chris Murphy wrote:
> On Mon, Feb 18, 2019 at 5:28 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>> Rsync is probably i bad idea yes. I could btrfs send -p the changed
>> "new" master subvolume and then delete the old master subvolume and then
>> reference the new master subvolume when transferring it later on i guess=
?
> I'm not sure how your application reacts to snapshots or reflinks, or
> how it updates its files. All of that needs to be tested to see what
> the incremental send size is, and if the resulting received snapshot
> contains files with the integrity your application expects, and so on.
>
>> I'll explain the problem I'm trying to solve abit better;
>>
>> Say i have a program that will run in multiple instances. The program
>> requires a dataset of large files to run (say 20GB). The dataset will be
>> updated over time, i.e parts of them changes. These changes should only
>> apply to new instances for the program. The program will also generate
>> new data (both new files and also changing data in the the shared
>> dataset) that is unique to the instance of the child subvolume. Finally
>> I need to transfer the program together with its generated data to
>> another remote machine to continue it's processing there. What i want to
>> achieve is avoid having to transfer the entire dataset when only small
>> parts of it is changed by the program. I also want to avoid having to
>> duplicate copies of the data on the remote machine.
> Yep. Based on this description though, the only time I grok using
> 'btrfs send -p master.snap child.snap | btrfs receive /destination/'
> is for the initial transfer of child. Master must be already fully
> replicated. Now you can snapshot master and child on separate
> schedules to account for their different use case, and send their
> increments independent of each other. Or in fact maybe you'll realize
> you do have a use case for clone.
>
> Have you looked at GlusterFS or Ceph for this use case? I kinda wonder
> if there's any simplification to just having a clustered file system
> make all of the send/receive stuff go away, and you can ensure your
> data is replicated pretty much immediately, and is always available
> for all computers. *shrug* That's off topic but I'm curious if there
> are ways to simplify this for your use case.
>
>
>


