From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: snapshot/subvolume removal
Date: Tue, 12 Jan 2010 13:03:53 +0200
Message-ID: <4B4C5719.7020406@cs.bgu.ac.il>
References: <4B43AC9B.5030109@cs.bgu.ac.il> <4B4BC6D2.6030906@jp.fujitsu.com> <4B4C1FEA.70109@cs.bgu.ac.il> <201001121012.52665@fortytwo.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
	linux-btrfs@vger.kernel.org
To: Adrian von Bidder <avbidder@fortytwo.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001121012.52665@fortytwo.ch>
List-ID: <linux-btrfs.vger.kernel.org>

Adrian von Bidder wrote:
> Hi,
>
> On Tuesday 12 January 2010 08.08:26 Piavlo wrote:
>   
>> Maintaining snapshot hierarchy by  external application is not reliable
>> and error prone
>> compared to maintaining it withing the btrfs itself,
>> probably by adding the parent treeid field for every  shapshot/subvolume.
>>     
>
> What should, in your opinion, happen if the parent snapshot is deleted?  
> Orphan? Re-parent to parent of parent?
Re-parent to parent of parent.
And if there is no grandparent then  point to itself (like with root
directory).
This hierarchy should be tracked/modifed within same subvolume only - so
each subvolume has it's own snapshots hierarchy.
This would allow, for example, easy rollback of most recent subvolume
state to previous states (probably with btrfsctl)  without maintaining
snapshots hierarchy state in userspace applications.

 Thanks
  Alex
>   I guess depending on application, 
> there may be more than one "right" solution.
>
> cheers
> -- vbi
>
>   

