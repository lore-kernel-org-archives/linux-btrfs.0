Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53755 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3JKJgy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 05:36:54 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm2so792131wib.12
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 02:36:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <525750B4.4090009@cn.fujitsu.com>
References: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
	<525750B4.4090009@cn.fujitsu.com>
Date: Fri, 11 Oct 2013 12:36:52 +0300
Message-ID: <CAOi1vP81WfaMEHYXNE8FcD3p0arUiEGJzcDnBYmVwKbWoSHLcg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro mounts
From: Ilya Dryomov <idryomov@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 4:13 AM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> On 10/11/2013 01:40 AM, Ilya Dryomov wrote:
>
> I have a question in my mind.
>
> Can we reach a state that there is operation in progress when filesystem
> has been readonly?If we do cancel operations on a ro filesystem, we should
> get "No operations in progress" .

So if I understand you correctly you are saying that we should return
the "Not in progress" error code if the filesystem is mounted ro and
there is nothing to cancel.  I actually did think about it, but decided
against it because one can extend this argument to starting commands
with something like "If I order a start on a read-only fs and that
operation has already been started, I should get EINPROGRESS.", and
that's not what we are currently doing.

Thanks,

                Ilya
