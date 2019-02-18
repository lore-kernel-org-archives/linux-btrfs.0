Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F91AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 19:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB75C21773
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 19:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="bkZhG50n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfBRT6v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:58:51 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21383 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfBRT6v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 14:58:51 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550519926; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=QNBYCM7Cxu4dxv4744CipBnMfs1dnbHepRJUCAMuuG7LpGUvNbAIhXLguhlU9PBXtN7kWS5wf73Olg9t7W882psRD9AIzs+9PzPdXBJucEh2PK58QOtxsLaOoxVr0kFcuO3Y5fdcEnSyiZE5Olw/8gF5e4uTi2STLF9T/wxqIOM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550519926; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=qCukKfzJhCENWKfBqIy0bJv7Bg6u56vFABwFvS4PcXE=; 
        b=BbAN7bJSPb6DITKqof+8ROo4FPGEOyqOsPGeVP2mEbWXwYQIYyUeYQtU3r3JnjUYKirlaz+m31vZ3yl89kInJ8mplW37U60ss2HxOCFhlr8FaCLd2/Xkz+ryj+eKgqedBuBY3T/IowBeI/8yayrSTDtUHodj4kA5qV8oJ2f3I2o=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550519926;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=1839; bh=qCukKfzJhCENWKfBqIy0bJv7Bg6u56vFABwFvS4PcXE=;
        b=bkZhG50n0RYpw6undGUBPPVwAyUbOfWuc7zW97rXGw1YHTy0s3xgJGCUuWo1F12d
        zmXqJuClRulTtPBtoesfv+sL4GDuBs+go2LwXkz8pMInetEWuqBBtt+FEsds1NKJINY
        BPoadslQwoASH/aAPqpfBmHJYIWyx67kVLnj0l+o=
Received: from [192.168.0.4] (c83-248-74-133.bredband.comhem.se [83.248.74.133]) by mx.zoho.eu
        with SMTPS id 1550519924976567.3650358143249; Mon, 18 Feb 2019 20:58:44 +0100 (CET)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
 <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org>
 <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org>
Date:   Mon, 18 Feb 2019 20:58:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

What causes the extent to be incomplete? And can I avoid it? I tried=20
with my example but with wget with a larger file (1G) and the diff=20
produces was only 60MB which indicates that it "mostly" works.

Basically what I'm trying to achieve is having a "reference" / "master"=20
btrfs subvolume where i add / edit / remove files continuously. From=20
where i can cp --reflink=3Dalways some of those files to new "child"=20
subvolumes as needed. As long as the files are still in the master=20
subvolume I'll only send the diff of the data. The plan is to have this=20
master subvolume across multiple remote machines (synced with rsync or=20
perhaps btrfs send / receive) and being able to update / change it as=20
needed but always only sending the diffs of the child subvolumes. Maybe=20
this is a bit optimistic.

On 2019-02-18 19:06, Chris Murphy wrote:
> On Mon, Feb 18, 2019 at 6:05 AM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>> So the takeaway from this is that btrfs send doesn't work this way, I
>> can't copy a file with reflink=3Dalways and expect it to be diffed
>> correctly as in a parent-child situation or?
> Sorry about the confusion, Andr=C3=A9. What you're doing isn't described =
or
> explained in existing documentation: man page, wiki, or list archive,
> it's only explained in this thread. So, all I can say is it's going to
> take some testing on your part and possibly documentation and example
> improvements, for this alternative usage.
>
> At the moment, based on Andrei's explanation and example, what you're
> trying to do is valid. He also explained why you're seeing different
> results in send stream output in your dd vs wget example: it's the
> files themselves not the application.
>
> "The last extent is incomplete which causes btrfs to not attempt cloning.=
"
>


