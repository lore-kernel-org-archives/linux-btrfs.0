From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: Btrfs switches to using mostly one thread
Date: Fri, 09 Dec 2011 14:22:05 +0000
Message-ID: <4EE2198D.2020701@jeremysanders.net>
References: <jbqkib$v1g$1@dough.gmane.org> <20111208153201.GJ8971@shiny> <4EE0EC68.6040505@jeremysanders.net> <20111208172316.GP8971@shiny> <4EE0F644.6000204@jeremysanders.net> <20111208201112.GU8971@shiny> <4EE1F994.4060908@jeremysanders.net> <20111209141816.GA8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111209141816.GA8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/11 14:18, Chris Mason wrote:

> According to this you've only got one delalloc worker.  That would
> explain it.  Could you please confirm with ps?

Yes - only one delalloc worker is now present, but there were at least 
three initially.

Jeremy


