Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60412 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741Ab3DINNX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 09:13:23 -0400
Received: by mail-wi0-f181.google.com with SMTP id hj8so3645581wib.8
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Apr 2013 06:13:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130403172326.GD18365@twin.jikos.cz>
References: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
	<CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com>
	<CAFWF=a=iuvwUdSe7JuH3fMF1vugv4J90nV2D2cZV0E_LXj8RWQ@mail.gmail.com>
	<CAFWF=annpxTBF2_E=LThnqvc942ov=7ivBBqvDGDfci8haMWSA@mail.gmail.com>
	<20130403172326.GD18365@twin.jikos.cz>
Date: Tue, 9 Apr 2013 16:13:22 +0300
Message-ID: <CAOcd+r3LxyxgbkcT+JgnnLkwLy=V=0Gy6ZzY-dLu30b61X_nmg@mail.gmail.com>
Subject: Re: Backup Options
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: dsterba@suse.cz, Harald Glatt <mail@hachre.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,
maybe my old patch
http://www.spinics.net/lists/linux-btrfs/msg19739.html
can help this issue?

Thanks,
Alex.


On Wed, Apr 3, 2013 at 8:23 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Apr 03, 2013 at 04:33:22AM +0200, Harald Glatt wrote:
>> However what I actually did was:
>> # cd /mnt/restore
>> # nc -l -p 4444 | btrfs receive .
>>
>> After noticing this difference I had to try it again as described in
>> my mail and - oh wonder - it works now!! Giving 'btrfs receive' a dot
>> as a parameter seems to fail in this case. Is this expected behavior
>> or a bug?
>
> Bug. Relative paths do not work on the receive side.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
