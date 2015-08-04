Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24861 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbbHDW2t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 18:28:49 -0400
Message-ID: <55C13C92.7040103@oracle.com>
Date: Wed, 05 Aug 2015 06:28:34 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: fix null pointer dereference when extent buffer
 is already freed
References: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>	<1438699433-1581-3-git-send-email-anand.jain@oracle.com> <CAL3q7H4QsbcAuq5Az59_SaONcZtZ9frJ7q14kCtMds7LkqGg2A@mail.gmail.com>
In-Reply-To: <CAL3q7H4QsbcAuq5Az59_SaONcZtZ9frJ7q14kCtMds7LkqGg2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Wasn't this already solved by commit [1] added in the last 4.2-rc?

  Ah yes. it does.

Thanks, Anand
