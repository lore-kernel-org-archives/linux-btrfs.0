Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EFBECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 09:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6862064A
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 09:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ceremcem-net.20150623.gappssmtp.com header.i=@ceremcem-net.20150623.gappssmtp.com header.b="WFNc9zo/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA6862064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ceremcem.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbeJSRrG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:47:06 -0400
Received: from mail-vs1-f49.google.com ([209.85.217.49]:32836 "EHLO
        mail-vs1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbeJSRrF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 13:47:05 -0400
Received: by mail-vs1-f49.google.com with SMTP id e206so24936686vsd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 02:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ceremcem-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=9LmcW/ShRlfCGYiwe+RmGgzFhMfOFHvJfAwcEC41AcA=;
        b=WFNc9zo/UfQEqJJost5k+o6ODUMhzx9ueYbLzOAv9zzsXpH23eTTh7WnfYMXp2o4r7
         xD7z8+JJIv1GRFKKqDgfztbaGBDSJfP/182TySthjGPtZM2Tdly3JsmlMCvDtmS+UK4z
         8LR9pba5+aEAg0u0mfxa2cBYksSYdssGiuGGxXvT0K5OP8nRYFu/eGICK/uDi40Vb2F3
         KWXRI14BVPEUWEH0e5yr449LPIH0RqWfZfSqTwiSvL34II+wPfmeBBUc9arq5Ir0Uvfx
         FCssPKi8T1803ZaT7mjGfu8uHylGu6Mi0UmPagOJVGE/V5K7Eyq/NlUQKezGwcMue8ww
         cH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9LmcW/ShRlfCGYiwe+RmGgzFhMfOFHvJfAwcEC41AcA=;
        b=gZgBf9I2LefWCTe2D8Kgn0QyTUJ9OsrlSJ2HfXRk1xJ+5FE5l5Os8EACttB5rhM85i
         oNpNcbBCcSS9Y1xgYnEV7kps6JJhG3yJ269is4QUWUSnDgUyViJkVmuKDFWUbz0MuBLl
         bpfahRFpcYi7N29nj1lWc4e+gxHVzitBh1Cx/jXk2pVzFRuVPD2YB9lc23J1fSxxWlNF
         GpqoIwAoB1n5Mu53rRm+OI90rx5wx62FVWhPIrGuFveCZfexslSW3XmvPBOOxbqKypxO
         6nnp6XAYR5VD/WQ+8bgjsE7gGYjUHnDP47xesQU+f7quxncQbzjoCTNOeb1GrVRczF5E
         n9Dw==
X-Gm-Message-State: ABuFfojkCaKdqpSefXhJ66aiR6h9347ONpdhDlxUzu/GE8soxwQWrU4t
        KZPqIr/wBf/kq9WTIdGF886SpSV/SQqV81xAScqTg8dofU0=
X-Google-Smtp-Source: ACcGV63soRZVeivGtUTOjZaNmVVBY7F+5za8PWHdoqkBB0RxA5nQB3o+H4rvR2sEyowXnYH1IGnl5EvBawtCJOfdtWk=
X-Received: by 2002:a67:4282:: with SMTP id p124mr13997132vsa.134.1539942106430;
 Fri, 19 Oct 2018 02:41:46 -0700 (PDT)
MIME-Version: 1.0
From:   Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date:   Fri, 19 Oct 2018 12:41:35 +0300
Message-ID: <CAN4oSBcEi7Lxt7D3KrZ=jtU3g=DtN7mwUpPQ8zLrvwRjtKRCXw@mail.gmail.com>
Subject: Is it possible to construct snapshots manually?
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

By saying "manually", I mean copying files into a subvolume on a
different mountpoint manually, then mark the target as if it is
created by "btrfs send | btrfs receive".

Rationale:

When we delete all common snapshots from source, we have to send whole
snapshot for next time. This ability will prevent sending everything
from scratch unless it's necessary.
(https://unix.stackexchange.com/q/462451/65781)

Possible workaround:

I've got an idea at the moment: What I want can be achieved by
dropping usage of "btrfs send | btrfs receive" completely and using
only rsync for transfers. After transfer, a snapshot can be created
independently on the remote site. Only problem will be handling the
renamed/relocated files, but `rsync --fuzzy` option might help here:
https://serverfault.com/a/489293/261445

Anyway, it would be good to have a built in support for this.
