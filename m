Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34263 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbbC2Tk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 15:40:57 -0400
Received: by igcau2 with SMTP id au2so60352481igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 12:40:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427656526.2251.8.camel@miceliux.com>
References: <1427656526.2251.8.camel@miceliux.com>
Date: Sun, 29 Mar 2015 13:40:56 -0600
Message-ID: <CAJCQCtQLPj2n=jO+s3z28_SdYL1mz97FBntK-0YLYn112EKBNg@mail.gmail.com>
Subject: Re: Cannot convert to raid1
From: Chris Murphy <lists@colorremedies.com>
To: Juan Orti Alcaine <juan.orti@miceliux.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 29, 2015 at 1:15 PM, Juan Orti Alcaine
<juan.orti@miceliux.com> wrote:

> The filesystem was created with one device, and I have added two more
> devices afterwards. To convert it to raid1, I have used:
>
> # btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/btrfs_raid1

> The balance process has finished, but if I check my filesystem, it
> shows up as single

Yeah, I'm kinda stumped. The only thing I'm thinking is if you're
absolutely sure it's mounted at /mnt/btrfs_raid1 – because I've made
this mistake before. (Oops.)

-- 
Chris Murphy
