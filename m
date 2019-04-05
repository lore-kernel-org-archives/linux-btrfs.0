Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52927C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 203B620700
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="rQoNC9mG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfDEGxf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 02:53:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46318 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfDEGxe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 02:53:34 -0400
Received: by mail-lf1-f68.google.com with SMTP id r25so3552334lfn.13
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 23:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EF/CYsbMeh6C3eHCdzJpXf6QFfOQvNisxR8tlydfEXk=;
        b=rQoNC9mG1OfDf38ytp2SVEQg5ZP1dFKzCWMRsg1aUCR/Ox3McpfYaAxy8YouWWvrVK
         t0e3JezQNmW33RUyGtHbMwUltUwOUz06k1CMIfnEi8j94FZVjg2Bq81RGjm77EnW+x/1
         s8g2ScGDmjgSivJAyw0iLwt+/V0AtcsvqELX9+x0tJHNGTGc54mcXvpM/D6qSSN1L93u
         XUob6xZO58AN5BIOScRkWBLiH7l++6o1Re/0qTWBYVzb4QhL+K8iHkivXkQRGxca6Qrz
         x/0qCe+Vsyia1hKRaWsGQB/QK6T4bf/jA3pDQ7O90cLOphvyTiVZHGlTXFRxeRFUctdZ
         2NlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EF/CYsbMeh6C3eHCdzJpXf6QFfOQvNisxR8tlydfEXk=;
        b=E17t2Dygxdr2iUq5ecBSxTT1KrfdsmfStLY3LJuKCL273nPOMJwsMDD2tT1lF4FGDS
         D0TkTITnv5GfxN6KkTaIJHSLOY9zNNiQ+fA1Im7FmzJaUWmiqs2ajCzSaiR6jWdcP3k1
         ngnx/p2ccCJjNHnZc6upUVD3n58ZPpW5Yw81PXmgkIxlqvI/+MjU6/eWvHEa5pg+OBXE
         cuBurW1wXSjOvLSd2kaUh3gxxRbXhOE5o0O5E3qIRa9PLJZMeIGE0okv647Ud13Mxq0L
         K+1Yvxr25pg3Tnbpz4N6tVOZJhStyJAYpyWyjGTnUwW+SLg3lkf0b7ERVna/YgheEcgm
         hCRA==
X-Gm-Message-State: APjAAAWPBqp4EXaf5y+xaDSEucjwLBif0eIjEBwIEhdNzeeDox2PRUII
        q773dHG/TSyxP13qFDTwN5KW3jpzqUmG0GfYNzTg73QcbJE=
X-Google-Smtp-Source: APXvYqxY57JnR25Gi+S5zX9WCLa32N7gwZoFX4OAQhNGx2roP30GvpLVCs9aUrZYC7/n3x+/2+C7Hqm6NjJuRnnvG5g=
X-Received: by 2002:a19:5201:: with SMTP id m1mr5561386lfb.68.1554447213089;
 Thu, 04 Apr 2019 23:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu> <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
In-Reply-To: <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 5 Apr 2019 00:53:21 -0600
Message-ID: <CAJCQCtTdsN6=btx_iRn-FNQT7ZneQnfguscZ5qC552B1xiFB4w@mail.gmail.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 3, 2019 at 8:48 PM Jeff Mahoney <jeffm@suse.com> wrote:
>
> My team is always interested in images of broken file systems.  This is
> how --repair evolves.  Images with failed --repair operations are still
> valuable.  That's the first step most users take and why wouldn't they?
>  If --repair is misbehaving, the end result shouldn't be "I hope you
> have backups."

Ok well there's a lot of that still happening. So what switches should
users use for images these days? It's not obvious whether there's
extent tree corruption so are they best off always using -w? And I
know Qu doesn't like images with either -s or -ss, and I don't think
users care which one they use, but it's not reasonable that they
supply images that don't have file and dir names scrubbed. And then
where and how should they submit the images?

I haven't taken an image yet but do have a file system that was
working fine before using btrfs-progs 4.19.1 with --clear-space-cache
v1 that definitely corrupted the extent tree. I have 0% confidence in
--repair or --init-extent-tree fixing it so I haven't tried it yet,
and it's a backup so it doesn't really matter. I did file a bug.
https://bugzilla.kernel.org/show_bug.cgi?id=202717


-- 
Chris Murphy
