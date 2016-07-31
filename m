Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36404 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbcGaK5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 06:57:34 -0400
Received: by mail-wm0-f43.google.com with SMTP id q128so337747341wma.1
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 03:57:33 -0700 (PDT)
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
From: Gabriel C <nix.or.die@gmail.com>
Message-ID: <2f672600-c80b-c884-6da3-07b067a1816d@gmail.com>
Date: Sun, 31 Jul 2016 12:56:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.07.2016 22:02, Chris Murphy wrote:
> Short version: When systemd-logind login.conf KillUserProcesses=yes,
> and the user does "sudo btrfs scrub start" in e.g. GNOME Terminal, and
> then logs out of the shell, the user space operation is killed, and
> btrfs scrub status reports that the scrub was aborted. [1]
> 

How this is a bug ?

Is excatly what 'KillUserProcesses=yes' is extected to do..

