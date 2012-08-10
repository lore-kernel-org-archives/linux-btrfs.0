Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:55190 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2HJMtp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 08:49:45 -0400
Message-ID: <50250346.5010807@csamuel.org>
Date: Fri, 10 Aug 2012 22:49:10 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
CC: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG on 3.5.0
References: <20120808161819.GO25996@vicerveza.homeunix.net> <20120808173645.GA17430@twin.jikos.cz> <20120808174011.GD2141@localhost.localdomain> <20120808175606.GQ25996@vicerveza.homeunix.net> <20120808175833.GC4185@shiny> <20120810094959.GT25996@vicerveza.homeunix.net>
In-Reply-To: <20120810094959.GT25996@vicerveza.homeunix.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2012 07:49 PM, Lluís Batlle i Rossell wrote:

> Am I right that it is not in 3.5.1?

I don't believe fixes can be considered for stable releases until 
they're in the mainline, so until Linus processes that last merge 
request from Chris it can't happen (and he's not done so yet).

That said, there was one btrfs fix merged into 3.5.1:

Chris Mason (1):
       Btrfs: call the ordered free operation without any locks held

But I suspect that is not the fix you are looking for..

cheers,
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
