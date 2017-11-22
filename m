Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:43147 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdKVQj5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 11:39:57 -0500
Received: by mail-oi0-f54.google.com with SMTP id h6so11317445oia.10
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 08:39:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511364964.1675.57.camel@gmail.com>
References: <1511364964.1675.57.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Nov 2017 09:39:55 -0700
Message-ID: <CAJCQCtR37A4GEC3UZs=W0AMiB+XR67BnoN9VZZrX4GPNOVdntQ@mail.gmail.com>
Subject: Re: mail notifications to root once quota limit reached
To: ST <smntov@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 8:36 AM, ST <smntov@gmail.com> wrote:
> Hello,
>
> is it possible to get mail notifications to root once quota limit is
> reached? If not should I file a feature request?

You should look at Nagios or OpenNMS, etc. That's where such
functionality belongs.

-- 
Chris Murphy
