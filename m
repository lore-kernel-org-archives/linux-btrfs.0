Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44624 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751840AbaBFVXd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 16:23:33 -0500
Message-ID: <52F3FD4F.2010705@fb.com>
Date: Thu, 6 Feb 2014 16:23:27 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Convert BUG() to BUG_ON(1)
References: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2014 01:34 PM, Mitch Harder wrote:
> Convert the instances of BUG() to BUG_ON(1) to provide information
> about the location of the abort.
>

This is where I realize this was against btrfs-progs, ignore me.  Thanks,

Josef
