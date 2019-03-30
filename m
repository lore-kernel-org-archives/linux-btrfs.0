Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A810C10F00
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 684DB2146F
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZLwOfUNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbfC3NFI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 09:05:08 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:42499 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730799AbfC3NFI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 09:05:08 -0400
Received: by mail-ed1-f46.google.com with SMTP id x61so4290741edc.9;
        Sat, 30 Mar 2019 06:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OcIV8+1AC9xA1MsE5GdTUPWNInrXd3mCdewr7SGloZw=;
        b=ZLwOfUNdm9d8An/bMq7Y7dKq2wqplePCSDW9ufgHkAC1Un3TGqKpZAP2TZPI5AlgkQ
         nmtWTiCQWlNhALZTpr/uluhwpxbTR+I7Mq/HDY4jOF37AGAM2hq18pDVqhA82CgtiDhL
         PodDZh9dVsXI9oL4gfu6dLlHQoUGz4E5++Km5ZQNr4b5/WtKHTLn8/sCJaocU8ikhlST
         1JoRF4OVSc3k9K02oPdMH9xFrxhqF6YpaCo6pl3Y+sFdTBIksOLD05NODxOHqNkl8/2I
         +bNn1k5vFsTXkRNBcMMjwg4dDvC4Ndxc2sLZuaU8yCMZ+8lhLwkZurXAv+oG8bwZPDiH
         MzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcIV8+1AC9xA1MsE5GdTUPWNInrXd3mCdewr7SGloZw=;
        b=nYZmVjBlPzVR5V0FDzgoUBZuRn5RM7hxcweDW0wXwUcLib8gdXiz0IKmUfBlFCCBrG
         vspxUS/bb/KEZmDgVHigr9Cc0Tq6JLqTAryTo8WhcIQFn6J6p6i/7taehdQL0v89KK5q
         zMlAslw9uO32Vdc+eZv+j9W0pUMYetMH+44ok4i5U2ZtvAJY+SZb215jSJUY78IO+t4V
         pdwkr2MXG0CgQSniH5ow9qJxgxdte+g+GFXWaYsGO7PzQJGfVYbKCVXkiRHYAD/Xokdo
         Vibj+n8xyNJ9Oi47VTOQOaHTGraf6TUgyd7OGnQYi9kN391YqUWx7/xJjAMq6XCpv0Ia
         B+IQ==
X-Gm-Message-State: APjAAAVxf8VH7SOy+tRUmuFuuSvy7tfvw1ur7TI7fQxIeU2fnBvWh7i6
        oB4mDDMO4gxBHMyzKgz2gJOtGlZMkSBhEArfuCWEQeBl
X-Google-Smtp-Source: APXvYqzIWrGN2Z+MgiIyarEJVA0E2XcWmvsJ415lOJ21+4GmBzoFAEGyNYnBYON44nvNq5XRSz90g4KaT5em4j/1yKc=
X-Received: by 2002:a50:8ba6:: with SMTP id m35mr36746344edm.33.1553951105925;
 Sat, 30 Mar 2019 06:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com> <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
In-Reply-To: <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
From:   Supercilious Dude <supercilious.dude@gmail.com>
Date:   Sat, 30 Mar 2019 13:04:54 +0000
Message-ID: <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush correctly?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 30 Mar 2019 at 13:00, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> I'm purposing to measure the execution time of flush/fsync, not write.
>
> And if flush takes 0ms, it means it doesn't really write cached data
> onto disk.
>

That is correct. The controller ignores your flush requests on the
virtual disk by design. When the data hits the controller it is
considered "stored" - the physical disk(s) storing the virtual disk is
an implementation detail. The performance characteristics of these
controllers are needed to make big arrays work in a useful manner. My
controller is connected to 4 HP 2600 enclosures with 12 drives each.
Waiting for a flush on a single disk before continuing work on the
remaining 47 disks would be catastrophic for performance.

Regards
