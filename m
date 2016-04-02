Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35904 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbcDBTkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Apr 2016 15:40:09 -0400
Received: by mail-lb0-f182.google.com with SMTP id qe11so105681355lbc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 12:40:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160402203117.4d815f13@jupiter.sol.kaishome.de>
References: <20160326203035.4b876a04@jupiter.sol.kaishome.de>
 <20160327035038.5ab6e64b@jupiter.sol.kaishome.de> <56F7E65C.7020300@gmx.com>
 <20160328120203.1b8d79dc@jupiter.sol.kaishome.de> <56FC7E6D.8010805@cn.fujitsu.com>
 <56FC8C15.5060002@cn.fujitsu.com> <20160331210004.GZ9342@torres.zugschlus.de>
 <20160331231630.7b4ceda9@jupiter.sol.kaishome.de> <20160401055725.GA9342@torres.zugschlus.de>
 <20160402110353.10ae123a@jupiter.sol.kaishome.de> <20160402094432.GQ9342@torres.zugschlus.de>
 <20160402203117.4d815f13@jupiter.sol.kaishome.de>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sat, 2 Apr 2016 21:39:48 +0200
Message-ID: <CAA7pwKM55Addz2PZ-p0OGvG=zcn2jSUMpTUMJp0RDbrpPa4uaw@mail.gmail.com>
Subject: Re: bad metadata crossing stripe boundary
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 April 2016 at 20:31, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Sat, 2 Apr 2016 11:44:32 +0200
> schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:
>
>> On Sat, Apr 02, 2016 at 11:03:53AM +0200, Kai Krakow wrote:
>> > Am Fri, 1 Apr 2016 07:57:25 +0200
>> > schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:
>> > > On Thu, Mar 31, 2016 at 11:16:30PM +0200, Kai Krakow wrote:
>>  [...]
>>  [...]
>>  [...]
>> > >
>> > > I cryptsetup luksFormat'ted the partition before I mkfs.btrfs'ed
>> > > it. That should do a much better job than wipefsing it, shouldnt
>> > > it?
>> >
>> > Not sure how luksFormat works. If it encrypts what is already on the
>> > device, it would also encrypt orphan superblocks.
>>
>> It overwrites the LUKS metadata including the symmetric key that was
>> used to encrypt the existing data. Short of Shor's Algorithm and
>> Quantum Computers, after that operation it is no longer possible to
>> even guess what was on the disk before.
>
> If it was encrypted before... ;-)

What does wipefs -n find?
