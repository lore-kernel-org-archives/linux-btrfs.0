Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43833 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdFEIaN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 04:30:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dHnOn-0008IL-Iw
        for linux-btrfs@vger.kernel.org; Mon, 05 Jun 2017 10:30:05 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Re: snapshot destruction making IO extremely slow
Date: Mon, 5 Jun 2017 10:30:02 +0200
Message-ID: <adhf0e-2dm.ln1@aldebaran.xundeenergie.at>
References: <550E7917.5030602@gmail.com>
 <20150325011937.GB20767@twin.jikos.cz> <55129428.7090508@gmail.com>
 <20150330142532.GI32051@suse.cz> <55196740.1000705@gmail.com>
 <20150331170516.GD6821@suse.cz> <5534CC2F.4080109@gmail.com>
 <553912EF.7010004@gmail.com>
 <CAKbZ4cK8-Fh6MvS1X4Tj-S9k6VBgaPEFj8x30de3NQf-UdZBrg@mail.gmail.com>
 <76463d77-7747-c27b-e874-cea1f88edd05@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <76463d77-7747-c27b-e874-cea1f88edd05@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2017-05-24 um 10:23 schrieb Marat Khalili:
> Hello,
> 
>> It occurs when enabling quotas on a volume. When there are a
>> lot of snapshots that are deleted, the system becomes extremely
>> unresponsive (IO often waiting for 30s on a SSD). When I don't have
>> quotas, removing snapshots is fast.
> Same problem here. It is now common knowledge in the list that qgroups
> cause performance problems. I try to avoid deleting many snapshots at
> once because of this.

I enabled quota a few weeks ago, then my system gets so unresponsible,
that services stopped working and nothing worked anymore... disabling
qouta was also not able, it endet up in a kernel-panic and frozen system.

Hat to reinstall my system back from the backup...

greetings
Jakob

