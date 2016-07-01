Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35113 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbcGAAQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 20:16:52 -0400
Received: by mail-qk0-f181.google.com with SMTP id a125so176914043qkc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:16:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1fb4624c-4a2f-6076-0883-4a7bff395821@oracle.com>
References: <CAGqmi75KFyiCzF2J5Xa_a8S27iR6Kp1jxH4JcwHBe1pD8m1egg@mail.gmail.com>
 <1fb4624c-4a2f-6076-0883-4a7bff395821@oracle.com>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Thu, 30 Jun 2016 20:16:51 -0400
Message-ID: <CAD=QJKg9_zeVGS+apkGK6b6n1EC4N=br01aP9Dn=W_ssHzEgcA@mail.gmail.com>
Subject: Re: RAID1: if one disk failed, what errors are expected?
To: Anand Jain <anand.jain@oracle.com>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 June 2016 at 07:57, Anand Jain <anand.jain@oracle.com> wrote:
>
> Right. Application shouldn't notice the EIO. First of all,
> we are not stopping IO to the disk which is pulled out. The
> below patches 11/13 and 12/13 fixes it.
>
>  [PATCH 11/13] btrfs: introduce device dynamic state transition to offline
> or failed
>  [PATCH 12/13] btrfs: check device for critical errors and mark failed

When are these two patches expected to hit mainline?  Do you think
they'll be merged before linux-4.10?

Cheers,
Nicholas
