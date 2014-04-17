Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51308 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQQLS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 12:11:18 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so838881eek.36
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Apr 2014 09:11:17 -0700 (PDT)
Message-ID: <534FFD22.1060500@gmail.com>
Date: Thu, 17 Apr 2014 18:11:14 +0200
From: "Oliver O." <oliver.o456i@gmail.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: File changing in snapshot
References: <534FF5C1.8070404@gmail.com> <534FF9B5.4010207@fb.com>
In-Reply-To: <534FF9B5.4010207@fb.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 17.04.2014 17:56, schrieb Chris Mason:
> On 04/17/2014 11:39 AM, Oliver O. wrote:
>> I seem to have observed a file on a (writable) snapshot changing
>> although there were no writes occuring on the snapshot itself. This is
>> not supposed to happen, right?
>
> Was this a nodatacow file?
>
> -chris

No. Mount options:

/dev/sda2 on /home type btrfs (rw,noatime,nodiratime,subvol=@home)

