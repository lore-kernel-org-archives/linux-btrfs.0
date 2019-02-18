Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728B9C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 18:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CDEE21736
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 18:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="WAnWKvcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbfBRSAg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:00:36 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:37101 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387420AbfBRSAf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 13:00:35 -0500
Received: by mail-lj1-f169.google.com with SMTP id r10-v6so15151413ljj.4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 10:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sTQqjYQgtD5fwL8dz/RDy2SZCmmSHS4a71eMXOnUjGo=;
        b=WAnWKvcMsUev3+6mvbE/TIGI8ragJrKscDFxSQgOzHQHXUiVeV8mZ1u2mLRP/txXOB
         w6+iNrqJyeo+nKhC5S5Dq7NJicE5ijUSnLhpn7UCTUG5JvkYDiQ0fM1xZ2IO9eZ5b1kI
         OS4lVvYpruML7ngHK6DC2PdDFelky8R/Z63pV5WzT1cuivXMt1P7C+VOB3e/aua0BW6h
         I8H1h1hb8uo9hxuqdzZ+PKO1Q2VHiIwCQZKIJuGdk9DSDE5r6bBrtCF6EV9lNRLKgDEk
         QeNeG1k1NT6Aokre4rKjG6TdwZor0AlnXoN8OmE3Dicx7GAIURLWJPL8OEfOvJkdDGuU
         1jDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sTQqjYQgtD5fwL8dz/RDy2SZCmmSHS4a71eMXOnUjGo=;
        b=Cwh60YMQ3MLd7lovC7urUM/IlQ+I3HIkyzAtq1etzIwuqF0nWCWWmjNnCVUgS9lCiU
         3q1XB5I/FqfhbcjmWc4ecywkNXLbmNkW3CIWeSS0I8cccGubHgiHF6NLyARQWaliapMl
         1TcXIgztcJM3kNLGGvns0rlvmoojxo3jrK9hKno1WSsDSadJJW+2MiX7lvZBYtGPAg1+
         cCXZ5nLCaosJuVq+zh802CdPlAxl9fpPHPA8SRsQaTGqGVGWJXRMy0BM9U4w74eTE3Mi
         RqR3d5rPM4JIH3yvJSQ5+MxaLm9whQDbzryMh3pYr9F8KrFiP+Fc1MEzTUevpk5MvU0c
         6IOg==
X-Gm-Message-State: AHQUAuaTZ7HfPZ00NT1UjbuqEQZtiRiX4jq/mhSjnIRln9D9NlVFSgJ1
        oTM1NcLLpSHUsr8NRJeQSHvGS/HGU8ipdXgzUTjAPw==
X-Google-Smtp-Source: AHgI3Iab+0O+f01hNwLKStl5FtguGAq6VSnEznuvbPMW0JtdCbzqAMt4641rpfI1a5OGFMOh/KpcQS+ZpjdeGsM4kUk=
X-Received: by 2002:a2e:2202:: with SMTP id i2mr10680561lji.170.1550512833350;
 Mon, 18 Feb 2019 10:00:33 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <1c6a1abb-1e6e-504a-b51c-0da580c49d66@gmail.com> <CAJCQCtTO0-WG+mHHvsUdQBJhuQ63dPkBqJP96vz7CU4jGF+hxA@mail.gmail.com>
 <1cd9e028-931d-0ca3-8ece-710a039c552b@gmail.com>
In-Reply-To: <1cd9e028-931d-0ca3-8ece-710a039c552b@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 11:00:21 -0700
Message-ID: <CAJCQCtRfHV39e=sNc+dzy2Od_6C1yha0BtNKqeXBbDEoytc3SQ@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 16, 2019 at 1:26 PM Andrei Borzenkov <arvidjaar@gmail.com> wrot=
e:
>
> 15.02.2019 22:11, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> > The proven way it works, is as I've described, and many emails over a
> > decade on this list, inferred from the man page, and the step by step
> > recipe on the Wiki.
> >
>
> Oh well.

OK, you're right, I'm wrong, however your example is the only one I've
seen in ~10 years that describes this alternative.

> btrfs send computes differential stream. Whether it will be
> "incremental" or not depends on how you are using it.

Yes, it's a difference computation, but the 'man btrfs-send' page
explicitly says incremental which is not the same thing.

Also adding 'btrfs receive' is important to test your example. I've
seen 'btrfs send' succeed where 'btrfs receive' complains.


>Stream contains differences between the first and the
> second stream, where order does matter. "Incremental" implies temporal
> ordering between two snapshots which does not exist on "btrfs send"
> level and must be ensured by tools that use "btrfs send/receive".

It's fine to have this alternative explanation. However the existing
'man btrfs-send' page says there are two modes: full and incremental.

--=20
Chris Murphy
