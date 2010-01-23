From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Btrfs st_nlink for directories
Date: Sun, 24 Jan 2010 02:12:59 +0530
Message-ID: <878wbomu24.fsf@linux.vnet.ibm.com>
References: <20100123022812.GA16124@arctrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Neil Schemenauer <nas@arctrix.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100123022812.GA16124@arctrix.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 22 Jan 2010 20:28:12 -0600, Neil Schemenauer <nas@arctrix.com> wrote:
> Hi,
> 
> It looks like Btrfs does not follow Unix traditions for st_nlink
> attribute of directories. It seems to be always one, no matter the
> number of sub-directories.
> 
> Is this intentional? I couldn't find it discussed anywhere. I
> gather the Mac OS HFS+ doesn't follow traditional st_nlink behavior
> as well. The 'find' man page has this note:

I have sent patches with message-id
1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
to the list. Let me know if they works for your

-aneesh


