From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 23 Feb 2012 20:02:38 +0800
Message-ID: <4F462ADE.4040507@oracle.com>
References: <4E4B2452.9070407@oracle.com> <1483419.CO5JBoDgFX@bursa22>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1483419.CO5JBoDgFX@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>



  autosnap code is available either end of this week or early
  next week and what you will notice is autosnap snapshots
  are named using uuid.

  Main reason to drop time-stamp based names is that,
     - test (clicking on Take-snapshot button) which took more
   than one snapshot per second was failing.
     - a more descriptive creation time is available using a
    command line option as in the example below.
  -----
  # btrfs su list -t tag=@minute,parent=/btrfs/sv1 /btrfs
  /btrfs/.autosnap/6c0dabfa-5ddb-11e1-a8c1-0800271feb99 Thu Feb 23 13:01:18 2012 /btrfs/sv1 @minute
  /btrfs/.autosnap/5669613e-5ddd-11e1-a644-0800271feb99 Thu Feb 23 13:15:01 2012 /btrfs/sv1 @minute
  -----
  
  As of now code for time-stamp as autosnap snapshot name is
  commented out, if more people wanted it to be a time-stamp
  based names, I don't mind having that way. Please do let me know.

Thanks, Anand
   

On Thursday 23,February,2012 06:37 PM, Hubert Kario wrote:
> On Wednesday 17 of August 2011 10:15:46 Anand Jain wrote:
>>    btrfs auto snapshot feature will include:
>>    Initially:
> <snip>
>>        - snapshot destination will be subvol/.btrfs/snapshot@<time>  and
>>          snapshot/.btrfs/snapshot@<time>  for subvolume and snapshot
>>          respectively
>
> Is there some reason not to use the format used by shadow_copy2 overlay for
> Samba? (The one providing Shadow Volume Copy functionality for Windows
> clients):
>
> Current date in this format you get like this:
>
> @GMT-`date -u '+%Y.%m.%d-%H.%M.%S'`
>
> For example: @GMT-2012.02.23-10.34.32
>
> This way, when the volume is exported using Samba, you can easily export
> past copies too, without creating links.
>
> Regards,
