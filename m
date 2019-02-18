Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386FEC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 13:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFCCE20645
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 13:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="Lp/dekbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbfBRNFd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 08:05:33 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21318 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbfBRNFd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 08:05:33 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550495130; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=XjwZN5oweOrnTbc7AIyvfaH4rOhtFxstXec2NERi3T9lQsmm6tkUiQw5A9wOoD1iHmNGO1ruvLsQ8MHQDSvpObtlQcHldlTt2OiT1c/I1IVunVPifqXE5ZxMWJMCBZDhRSPA3WqmV2lz9+1tQrYdb68dJC49sKWhjtKxZ5XtN4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550495130; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=XdjboDSpYjQgLnHrvu2QkTlc+4q7CzDhWsl4Q3NFxlg=; 
        b=XebHmt/ZNQsJWBEUB0nQJGMAgsTaCL+fnFTaHOqT8KuC40K0dcCedSJYveRc4MFUkDcyWQfsFsqOuWwixOL8seo1Tpapp24SIX2bYPH1VOicCb/UX/2270eqnAQnxa9uZejXbJ9FzaX4WPHX35LfXyG3Is1Q8kvvlAtYF8wpXbg=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550495130;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=971; bh=XdjboDSpYjQgLnHrvu2QkTlc+4q7CzDhWsl4Q3NFxlg=;
        b=Lp/dekbxcdpMSpeVTRVhvxdsnJB6qvALKWsC9Id5Jtfs2sKXaKysJDAWA209cVXj
        FiPuZjhcPZcQtrZWPdKTt2zn7tVfdt2I3kTMFng7b6jSpVtd5IxKXRT9htu8WgHHZfj
        qAJDEkkFJ7lWgr2KiRB5FZZNYA2urDpvWt6oq/Fo=
Received: from [10.0.0.20] (195-198-161-213-no22.tbcn.telia.com [195.198.161.213]) by mx.zoho.eu
        with SMTPS id 1550495128455892.1428159173402; Mon, 18 Feb 2019 14:05:28 +0100 (CET)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
 <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org>
Date:   Mon, 18 Feb 2019 14:05:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

So the takeaway from this is that btrfs send doesn't work this way, I 
can't copy a file with reflink=always and expect it to be diffed 
correctly as in a parent-child situation or?

On 2019-02-17 04:11, Remi Gauvin wrote:
> On 2019-02-16 3:08 p.m., Andrei Borzenkov wrote:
>
>> File size of "real" server.jar is not exact multiple of btrfs block size
>> (4096) which causes the last extent to be "incomplete". btrfs won't
>> clone extent in this case. You can trivially reproduce it by using the
>> same size in the first case (although exact extent distribution may be
>> different of course, in the worst case you get single extent which is
>> sent in full):
>>
>>
>>
>> dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=34625
>>
> Thank you.  I thought I had tested one where I changed the file size,
> (by  altering the bs,) but I must have inadvertently created a file that
> still divided by 4096, (or it got split into a second extent).
>
>

