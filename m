Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751903AbeGJLOE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 07:14:04 -0400
Date: Tue, 10 Jul 2018 13:13:59 +0200
From: David Sterba <dsterba@suse.cz>
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, "jbacik@fb.com" <jbacik@fb.com>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: A list of new findings when fuzzing Linux btrfs module
Message-ID: <20180710111359.GQ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <011B0D79-F8E6-46F1-9D82-8D60A4F3E925@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <011B0D79-F8E6-46F1-9D82-8D60A4F3E925@gatech.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 05:54:56PM +0000, Xu, Wen wrote:
> Hi BTRFS developers,
> 
> Here are a list of new issues I found:

Thanks for sending the list to the list, hopefully this will make the
bugs more visible as bugzilla gets low attention otherwise.
