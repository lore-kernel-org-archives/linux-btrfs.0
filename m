Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:48339 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761841Ab3DIPDd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 11:03:33 -0400
Message-ID: <51642DC2.3070308@giantdisaster.de>
Date: Tue, 09 Apr 2013 17:03:30 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: dsterba@suse.cz, Harald Glatt <mail@hachre.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Backup Options
References: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com> <CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com> <CAFWF=a=iuvwUdSe7JuH3fMF1vugv4J90nV2D2cZV0E_LXj8RWQ@mail.gmail.com> <CAFWF=annpxTBF2_E=LThnqvc942ov=7ivBBqvDGDfci8haMWSA@mail.gmail.com> <20130403172326.GD18365@twin.jikos.cz> <CAOcd+r3LxyxgbkcT+JgnnLkwLy=V=0Gy6ZzY-dLu30b61X_nmg@mail.gmail.com>
In-Reply-To: <CAOcd+r3LxyxgbkcT+JgnnLkwLy=V=0Gy6ZzY-dLu30b61X_nmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 9 Apr 2013 16:13:22 +0300, Alex Lyakas wrote:
> Hi David,
> maybe my old patch
> http://www.spinics.net/lists/linux-btrfs/msg19739.html
> can help this issue?
> 

The utimensat() call in process_utimes() needs the AT_FDCWD parameter to
be able to receive to relative directories.

I'm currently assembling a set of btrfs send/receive btrfs-progs related
fixes (including the "[PATCH] btrfs-progs: Fix the receive code pathing"
from you). A patch for AT_FDCWC is also included.


> On Wed, Apr 3, 2013 at 8:23 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Wed, Apr 03, 2013 at 04:33:22AM +0200, Harald Glatt wrote:
>>> However what I actually did was:
>>> # cd /mnt/restore
>>> # nc -l -p 4444 | btrfs receive .
>>>
>>> After noticing this difference I had to try it again as described in
>>> my mail and - oh wonder - it works now!! Giving 'btrfs receive' a dot
>>> as a parameter seems to fail in this case. Is this expected behavior
>>> or a bug?
>>
>> Bug. Relative paths do not work on the receive side.


