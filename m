Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37355 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdGCXVZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 19:21:25 -0400
Received: by mail-wm0-f53.google.com with SMTP id i127so121770463wma.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jul 2017 16:21:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5787bb34-0cfa-f074-505b-0c482cc16aee@mendix.com>
References: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
 <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com> <a2ec890c-ead0-4f9a-d338-a5a1a804cd28@petezilla.co.uk>
 <5787bb34-0cfa-f074-505b-0c482cc16aee@mendix.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 3 Jul 2017 17:21:18 -0600
Message-ID: <CAJCQCtSvCUR-TLieEMNMDEQAtB1=nSudzMGoSrRdTjE6uaOHyQ@mail.gmail.com>
Subject: Re: Deleting mounted subvolumes
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Pete <pete@petezilla.co.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's more like a bind mount of a directory, as far as what's going on
under the hood. I take it it's possible to delete a directory that is
bind mounted elsewhere? I'm not sure what happens though.



Chris Murphy
