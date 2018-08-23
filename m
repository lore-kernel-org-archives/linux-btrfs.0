Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f52.google.com ([209.85.167.52]:41216 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbeHWXun (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 19:50:43 -0400
Received: by mail-lf1-f52.google.com with SMTP id l26-v6so5027791lfc.8
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 13:19:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT-SwNYwLktME97RaC-NQTaCdq8JqWTDaeZhfZOzk6MXw@mail.gmail.com>
References: <CAA3ktqnSR59hSxpj1Pme-3fqJBqNu-A_kRu-VmX-5NrVpjHOoQ@mail.gmail.com>
 <CAJCQCtT-SwNYwLktME97RaC-NQTaCdq8JqWTDaeZhfZOzk6MXw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Aug 2018 14:19:22 -0600
Message-ID: <CAJCQCtTcCrWcfo0aCH6zx72=zmunkstcaqq=HMJh6fyfQTfHMQ@mail.gmail.com>
Subject: Re: Device Delete Stalls
To: Chris Murphy <lists@colorremedies.com>
Cc: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And by 4.14 I actually mean 4.14.60 or 4.14.62 (based on the
changelog). I don't think the single patch in 4.14.62 applies to your
situation.
