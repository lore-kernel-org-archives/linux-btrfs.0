Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC8EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 23:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F93204EC
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 23:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="CX3KP+Qv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbfBRX66 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 18:58:58 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21308 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfBRX66 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 18:58:58 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550534334; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=jBeeR5ito2NN9MQXlu94hNbSWqbaMJ3JJ7DrbogQ1gTlD4jEUNAcaO0ornrcWzLgXLyFpRdBp3r1KwvcspIJwmf9XUrtDgK0cZabBlvQlefaO1ThJeQ0wErtN0wxxK3XzLqeKt6hme3Wu3cx6bRvOBww5DL0T5tZeK8fONMc4LU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550534334; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=M0qcVgPZUEcuEqpFt2d3upAWWJA0W5rKMZUvNt7jg98=; 
        b=EqVxpIl0d2h4lDk692z+OFL3HuWxe25qJ2BpwhMt1E0rEmdSnvtDW7gJIuX9Kj6eKOPbjreul3wjllBDYA2r9wNCdTEv76w/o+Na1UQUTogcYS9+9EeatzXQcbt7eU+XZA/6qQ3CMD1KFBM3SUIEB4OCa0UOvPZy7xb01l9W+5E=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550534334;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=1804; bh=M0qcVgPZUEcuEqpFt2d3upAWWJA0W5rKMZUvNt7jg98=;
        b=CX3KP+QvGXUdQjIlCj0LxepgFr0ci12ehhHNhqDPsthhZOo0hYVNpVrJiF3djZQ3
        q2Ikh7H+piI3hij7tUOcIxld30QutnlGEekX9uxfpGTUpl7mcxIPv/m8nUxlocQRlrk
        wZfYJ1DF8vhNriy3klcbn/G2VJY4UakdzuyA0biM=
Received: from [192.168.0.4] (c83-248-74-133.bredband.comhem.se [83.248.74.133]) by mx.zoho.eu
        with SMTPS id 1550534333943668.2109183029409; Tue, 19 Feb 2019 00:58:53 +0100 (CET)
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
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <fec70b89-90ee-20b9-d47a-ae1be31361fc@sheepa.org>
Date:   Tue, 19 Feb 2019 00:58:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRvxpai3Cs+588T+QjYJbJSs2NE=nzkZ90FY41M9peXog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I assume i would have to use rsync (with --inplace possibly) to keep the=20
master volume in sync between machines?

Say for example I have a (large) file on master, on machine A, I cp=20
reflink it to a child subvolume. I then send -p child subvolume to=20
remote machine B (which already have the master volume). Then i change=20
parts of the file on the master of machine A. I then rsync (?) the=20
master volume so its the same across the machines. Can I then later send=20
-p the child volume, either back to the original machine (A) or to a 3rd=20
machine (C) given that the master volumes are synced?

About the efficiency I'm not planning to remove large amounts of data=20
that is used by child subvolumes (although some will be updated). But=20
given the unpredictability of what files will be used by child=20
subvolumes i might remove large unused amounts of data.

On 2019-02-19 00:49, Chris Murphy wrote:
> On Mon, Feb 18, 2019 at 3:58 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>> Ok, but I don't want to keep old snapshots of the child volumes. Only
>> the latest and then diffing it in regards to the master. Would that be
>> possible?
> In order to do an incremental send/receive you need to have the -p
> snapshot on both source and destination file systems. You can delete
> snapshots older than that.
>
> I still don't understand why you're diffing in regards to master. It's
> going to be inherently inefficient because you've said a large amount
> of the contents of master aren't important; but by using it as the -p
> reference snapshot, you're asking send to do a comparison that
> includes a lot of metadata you don't care about. It's more efficient
> to diff the incremental snapshots of the changing state of
> "childofmaster" subvolume.
>


