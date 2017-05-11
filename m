Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:36227 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdEKPTa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 11:19:30 -0400
Received: by mail-yw0-f169.google.com with SMTP id b68so14218233ywe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 08:19:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2b29db76-9199-0759-3477-58f0a67a3570@rqc.ru>
References: <2b29db76-9199-0759-3477-58f0a67a3570@rqc.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 11 May 2017 09:19:28 -0600
Message-ID: <CAJCQCtTbE6M23e8EmB23pp89Y8673BeY+p_tkox3orY-AS2DJQ@mail.gmail.com>
Subject: Re: Backing up BTRFS metadata
To: Marat Khalili <mkh@rqc.ru>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 11, 2017 at 8:56 AM, Marat Khalili <mkh@rqc.ru> wrote:
> Sorry if question sounds unorthodox, Is there some simple way to read (and
> backup) all BTRFS metadata from volume?

btrfs-image



-- 
Chris Murphy
