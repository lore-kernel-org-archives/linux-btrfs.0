Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35108 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdGDDmY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 23:42:24 -0400
Received: by mail-lf0-f47.google.com with SMTP id b207so111509739lfg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jul 2017 20:42:23 -0700 (PDT)
Subject: Re: Deleting mounted subvolumes
To: Chris Murphy <lists@colorremedies.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Pete <pete@petezilla.co.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
 <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com>
 <a2ec890c-ead0-4f9a-d338-a5a1a804cd28@petezilla.co.uk>
 <5787bb34-0cfa-f074-505b-0c482cc16aee@mendix.com>
 <CAJCQCtSvCUR-TLieEMNMDEQAtB1=nSudzMGoSrRdTjE6uaOHyQ@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <3d1c2598-3417-71e5-f3f6-39ff6223c031@gmail.com>
Date: Tue, 4 Jul 2017 06:42:20 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSvCUR-TLieEMNMDEQAtB1=nSudzMGoSrRdTjE6uaOHyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.07.2017 02:21, Chris Murphy пишет:
> It's more like a bind mount of a directory, as far as what's going on
> under the hood. I take it it's possible to delete a directory that is
> bind mounted elsewhere?

Yes, it is. Usual rules apply - it must be empty, but "rm -r" works as
well (and is more or less what happens when you delete subvolume is I
get it right).
