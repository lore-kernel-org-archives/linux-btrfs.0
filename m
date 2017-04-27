Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:56318 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161072AbdD0OHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 10:07:55 -0400
Date: Thu, 27 Apr 2017 19:07:51 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Gerard Saraber <gsaraber@rarcoa.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: No space left on device when doing "mkdir"
Message-ID: <20170427190751.2dc0e7ac@natsu>
In-Reply-To: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
References: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 27 Apr 2017 08:52:30 -0500
Gerard Saraber <gsaraber@rarcoa.com> wrote:

> I could just reboot the system and be fine for a week or so, but is
> there any way to diagnose this?

`btrfs fi df` for a start.

Also obligatory questions: do you have a lot of snapshots, and do you use
qgroups?

-- 
With respect,
Roman
