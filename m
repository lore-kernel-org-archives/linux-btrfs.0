Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:42962 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754013AbdIRNuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 09:50:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 18 Sep 2017 22:50:11 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Peter Becker <floyd.net@gmail.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <CAEtw4r19d8GsvzLD_OxBYxb7DoetpvmD3HySGKB9sFWtMQgF5A@mail.gmail.com>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <CAA91j0W5YNU-StfRY_M4YUC=aLY-W+VEZ+wP2XciiHmDB1q7gQ@mail.gmail.com>
 <d4dce3d04c11e171b44a1924114f5ddd@wpkg.org>
 <CAEtw4r19d8GsvzLD_OxBYxb7DoetpvmD3HySGKB9sFWtMQgF5A@mail.gmail.com>
Message-ID: <9b306b8b6083dee303b9724746ad01f3@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-18 22:44, Peter Becker wrote:
> i'm not sure if it would help, but maybe you could try adding an 8GB
> (or more) USB flash drive to the pool and try to start balance.
> if it works out, you can throw him out of the pool after that.

I really can't, it's an "online server".

But I've removed some 65 GB data, so now it's 171 GB free, or, 60% used 
filesystem.

The balance still fails.


Tomasz Chmielewski
https://lxadm.com
