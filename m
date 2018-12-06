Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12445C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 10:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB45D20672
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 10:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QT8KIE5J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB45D20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbeLFKFM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 05:05:12 -0500
Received: from mail-qt1-f175.google.com ([209.85.160.175]:36217 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbeLFKFM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2018 05:05:12 -0500
Received: by mail-qt1-f175.google.com with SMTP id t13so25645798qtn.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 02:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TvgKv9HE6mo5K6Q4VT1DQJG5AewbGF9IYLDsXsKsCnc=;
        b=QT8KIE5J18mt8JCqt/pLLOkCUkJGTTDt8wgOYdTTCYB9GVNf9eSrZxz7I6Cq9gvn7A
         jWP8LbzhMKOlXV0uQTaXnw1aD7AriVQZEGIu9eGpiI+xTJNULroga+ef1GhvLgixhXWb
         cEzqKgA2nXnr1r1gYzbVdXBwAkZUcok7mgQ24fJ4ns52536GJHnpFtF3aSfXaYtNlKGg
         hTGgTWz1gt/IkuVlSzfEUEPXIWRPZYMmgkBtI+XZriTf22feWFT3yAEkskqC0rGEVKxd
         py8SYq7WrbgBn6TqzSk4OX3xcYus7TY20Ms0OB5D9Aa5jY6oEkWTdLlZo7PK8Mfh3Ccm
         Yicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TvgKv9HE6mo5K6Q4VT1DQJG5AewbGF9IYLDsXsKsCnc=;
        b=ediLRBt8vArgHFkaF9/1TJOFvaLjFGZmyw3PhCmEz3Qk4i61lcveP/MJNF9djbrzQc
         k6Nqv8Zgx8vdnnkXMAqz39J3vJoM03vjcJ6fssCxIGOW9DeyyhXdLC0oaATi9hfg0VZq
         RUnI8nbPd+pViOB3Jln4cWtFYF+qInTuztJ6lxh0gi5LVozazxhsSzPVComueMZ/eGZu
         rrykz76pPr4/1iQtUrnqJRHXL9aPb1BbOCSbZ0Gvo3EOLbAKvscKoZ4SJToREfEPgHN5
         KZae01FFaqcuxZe/0C3AcDCzFQRl/EvXoNUO1qEZSSQMPxpzmxzSpBIflfGTq0I+snJv
         gWFg==
X-Gm-Message-State: AA+aEWYCcMGNqn+hXT60sd2YQypWt9SIexKKhzdrwL52odo3YF4t7V0f
        E+cNrVMJEcR7iUeRp8l/QnVYzOCXOhcwJLVP5us=
X-Google-Smtp-Source: AFSGD/W7zs2IW00etJrsNYBQWy83tjFa3y9w8YlDwbNMijlYHJNKvDWnfO/GpIro1KH4bk2v8fb+82KSefo0XjqSr6g=
X-Received: by 2002:a0c:fa46:: with SMTP id k6mr26476691qvo.36.1544090711234;
 Thu, 06 Dec 2018 02:05:11 -0800 (PST)
MIME-Version: 1.0
References: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
In-Reply-To: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 6 Dec 2018 20:04:59 +1000
Message-ID: <CAN05THR_jynDdBCkZae+HPEjLjDt9b8pG38y3cSz45YdQctocA@mail.gmail.com>
Subject: Re: What if TRIM issued a wipe on devices that don't TRIM?
To:     Robert White <rwhite@pobox.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I am more of a SCSI guy than ATA so forgive where I am ignorant.

The SCSI equivalent to TRIM is called UNMAP.
UNMAP is unfortunately only a "hint" to the device so if the device
for any reason
is busy,   it can just do a NO-OP, leave the data as is and still
return status SUCCESS.
That is not good if you want to wipe data for confidentiality reasons :-)

As UNMAP and TRIM are related make sure that TRIM actually provides a
guarantee to wipe the
data. I do not know ATA enough to know if it does or not.

In SCSI, instead of using UNMAP/TRIM  you can use WRITESAME10/16 which
can be used
and which does providde an overwrite/wipe guarantee. Maybe ATA has
something equivalent to
WRITESAME10/16.

I just want to say: be careful, sometimes these commands do not
provide a guarantee that they will actually
make the data overwritten/unretrievable.

ronnie sahlberg


On Thu, Dec 6, 2018 at 4:24 PM Robert White <rwhite@pobox.com> wrote:
>
> (1) Automatic and selective wiping of unused and previously used disk
> blocks is a good security measure, particularly when there is an
> encryption layer beneath the file system.
>
> (2) USB attached devices _never_ support TRIM and they are the most
> likely to fall into strangers hands.
>
> (3) I vaguely recall that some flash chips will take bulk writhes of
> full sectors of 0x00 or 0xFF (I don't remember which) were second-best
> to TRIM for letting the flash controllers defragment their internals.
>
> So it would be dog-slow, but it would be neat if BTRFS had a mount
> option to convert any TRIM command from above into the write of a zero,
> 0xFF, or trash block to the device below if that device doesn't support
> TRIM. Real TRIM support would override the block write.
>
> Obviously doing an fstrim would involve a lot of slow device writes but
> only for people likely to do that sort of thing.
>
> For testing purposes the destruction of unused pages in this manner
> might catch file system failures or coding errors.
>
> (The other layer where this might be most appropriate is in cryptsetup
> et al, where it could lie about TRIM support, but that sort of stealth
> lag might be bad for filesystem-level operations. Doing it there would
> also loose the simpler USB use cases.)
>
> ...Just a thought...
>
> --Rob White.
>
>
