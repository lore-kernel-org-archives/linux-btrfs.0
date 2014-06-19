Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15362 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbaFSCGL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 22:06:11 -0400
Message-ID: <53A246C6.5050408@fb.com>
Date: Wed, 18 Jun 2014 22:11:18 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>, Waiman Long <waiman.long@hp.com>
CC: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <t-itoh@jp.fujitsu.com>
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>	<53A20FFF.3010807@hp.com>	<53A2125B.3050701@fb.com>	<53A21702.8090109@hp.com>	<53A21C78.1040809@fb.com>	<53A21E84.2050103@hp.com>	<53A22064.7080400@fb.com>	<53A2212E.7090907@hp.com>	<53A2268F.3080807@fb.com>	<CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>	<53A22A01.7080505@hp.com>	<CAB9dFdvD9QMZ_rONhhP5ZD2E7+A7qxnsY978Snc3zHEbdPRszw@mail.gmail.com> <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com>
In-Reply-To: <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2014 10:03 PM, Marc Dionne wrote:
> On Wed, Jun 18, 2014 at 8:41 PM, Marc Dionne <marc.c.dionne@gmail.com> wrote:
>> On Wed, Jun 18, 2014 at 8:08 PM, Waiman Long <waiman.long@hp.com> wrote:
>>> On 06/18/2014 08:03 PM, Marc Dionne wrote:
> 
> And for an additional data point, just removing those
> CONFIG_DEBUG_LOCK_ALLOC ifdefs looks like it's sufficient to prevent
> the symptoms when lockdep is not enabled.

Ok, somehow we've added a lock inversion here that wasn't here before.
Thanks for confirming, I'll nail it down.

-chris

