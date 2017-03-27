Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38164 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdC0MAr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 08:00:47 -0400
Received: by mail-it0-f48.google.com with SMTP id y18so49558760itc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 05:00:46 -0700 (PDT)
Message-ID: <58D8FEEB.1080100@gmail.com>
Date: Mon, 27 Mar 2017 08:00:43 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: Marat Khalili <mkh@rqc.ru>
CC: linux-btrfs@vger.kernel.org
Subject: Re: backing up a file server with many subvolumes
References: <58D72EC4.9020101@gmail.com> <59dccd7e-6cb6-ea66-3150-0ce85472e73a@rqc.ru>
In-Reply-To: <59dccd7e-6cb6-ea66-3150-0ce85472e73a@rqc.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That is a very interesting idea.  I'll try some experiments with this.

Many Thanks for the assistance....:-)

J. Hart


On 03/27/2017 01:57 AM, Marat Khalili wrote:
> Just some consideration, since I've faced similar but no exactly same 
> problem: use rsync, but create snapshots on target machine. Blind 
> rsync will destroy deduplication of your snapshots and take huge 
> amount of storage, so it's not a solution. But you can rsync --inline 
> your snapshots in chronological order to some folder and re-take 
> snapshots of that folder, thus recreating your snapshots structure on 
> target. Obviously, it can/should be automated.
>
>

