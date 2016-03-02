Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33444 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcCBTto (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 14:49:44 -0500
Received: by mail-ig0-f169.google.com with SMTP id y8so2516120igp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 11:49:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B17A3235-6306-4BAF-9175-66806976C9CF@gmail.com>
References: <CAGTZdkyxxjfTP+1Ej-vpmMr7zRU7S_WHDQVzL1AcCe0iSQVx=w@mail.gmail.com>
	<CAJCQCtQ+inGUAKCG9LTCCcF7rxDq+hh8a=ngcUUfg2MYssVQDA@mail.gmail.com>
	<B17A3235-6306-4BAF-9175-66806976C9CF@gmail.com>
Date: Wed, 2 Mar 2016 12:49:44 -0700
Message-ID: <CAJCQCtT3aZYaDVk-PXFtJJjOuN7Q+X_iRy6r0ypycvQ984dAQA@mail.gmail.com>
Subject: Re: BTRFS Raid 6 corruption - please help with restore
From: Chris Murphy <lists@colorremedies.com>
To: Stuart Gittings <gittings.s@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 2, 2016 at 11:42 AM, Stuart Gittings <gittings.s@gmail.com> wrote:
> All devices are present.  Btrfs if show is listed below and shows they are all there.  I'm afraid btrfs dev scan does not help


What do you get for 'btrfs check'  (do not use --repair yet)




-- 
Chris Murphy
