Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37728 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750789AbdIJDNl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 23:13:41 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Sun, 10 Sep 2017 03:12:16 +0000
Message-ID: <5E342E49-3C3A-4A77-A2CB-46508684AD8D@fb.com>
References: <20170903010127.eafg2i7ry2tprro7@merlins.org>
 <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
 <20170903143142.7thdjvkmkdekrzc5@merlins.org>
 <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>
 <20170903144237.svgnaclwmcfdfikt@merlins.org>
 <AD68E364-AF7F-49AA-8376-49E0C7C92998@fb.com>
 <20170903202036.b7j6fcknfiisrnsl@merlins.org>
 <D509EEE0-1430-40C2-8AD4-117729CFADDD@fb.com>
 <20170909183918.guot5vuphgabevxi@merlins.org>
 <63F04FB0-47AD-4732-ACD6-B493C51F9ED4@fb.com>,<20170910023658.4y7u77tku3c6wj2t@merlins.org>
In-Reply-To: <20170910023658.4y7u77tku3c6wj2t@merlins.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok mount -o clear_cache, umount and run fsck again just to make sure.  Then if it comes out clean mount with ref_verify again and wait for it to blow up again.  Thanks,

Josef

Sent from my iPhone

> On Sep 9, 2017, at 10:37 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
>> On Sat, Sep 09, 2017 at 10:56:14PM +0000, Josef Bacik wrote:
>> Well that's odd, a block allocated on disk is in the free space cache.  Can I see the full output of the fsck?  I want to make sure it's actually getting to the part where it checks the free space cache.  If it does then I'll have to think of how to catch this kind of bug, because you've got a weird one.  Thanks,
> 
> Well, btrfs check was clean before, that, but now I returned this:
> gargamel:~# time btrfs check /dev/mapper/dshelf1  
> Checking filesystem on /dev/mapper/dshelf1  
> UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d  
> checking extents  
> checking free space cache  
> Wanted bytes 16384, found 196608 for off 13282417049600  
> Wanted bytes 536870912, found 196608 for off 13282417049600  
> cache appears valid but isn't 13282417049600  
> There is no free space entry for 13849889603584-13849889652736  
> There is no free space entry for 13849889603584-13850426474496  
> cache appears valid but isn't 13849889603584  
> Wanted bytes 5832704, found 81920 for off 13870290698240  
> Wanted bytes 536870912, found 81920 for off 13870290698240  
> cache appears valid but isn't 13870290698240  
> block group 13928272756736 has wrong amount of free space  
> failed to load free space cache for block group 13928272756736  
> Duplicate entries in free space cache  
> failed to load free space cache for block group 13962095624192  
> block group 14003434684416 has wrong amount of free space  
> failed to load free space cache for block group 14003434684416  
> block group 14470042615808 has wrong amount of free space  
> failed to load free space cache for block group 14470042615808  
> block group 14610702794752 has wrong amount of free space  
> failed to load free space cache for block group 14610702794752  
> block group 14612313407488 has wrong amount of free space  
> failed to load free space cache for block group 14612313407488  
> block group 14624661438464 has wrong amount of free space  
> failed to load free space cache for block group 14624661438464  
> block group 14648820629504 has wrong amount of free space  
> failed to load free space cache for block group 14648820629504  
> Wanted offset 14657410793472, found 14657410760704  
> Wanted offset 14657410793472, found 14657410760704  
> cache appears valid but isn't 14657410564096  
> block group 15886844952576 has wrong amount of free space  
> failed to load free space cache for block group 15886844952576  
> There is no free space entry for 15905635434496-15905636499456  
> There is no free space entry for 15905635434496-15906172305408  
> cache appears valid but isn't 15905635434496  
> block group 16542901207040 has wrong amount of free space  
> failed to load free space cache for block group 16542901207040  
> block group 16581019041792 has wrong amount of free space  
> failed to load free space cache for block group 16581019041792  
> block group 16616989392896 has wrong amount of free space  
> failed to load free space cache for block group 16616989392896  
> block group 16676582064128 has wrong amount of free space  
> failed to load free space cache for block group 16676582064128  
> block group 16697520029696 has wrong amount of free space  
> failed to load free space cache for block group 16697520029696  
> block group 16848380755968 has wrong amount of free space  
> failed to load free space cache for block group 16848380755968  
> ERROR: errors found in free space cache  
> found 11732749766656 bytes used, error(s) found  
> total csum bytes: 11441478452  
> total tree bytes: 13793296384  
> total fs tree bytes: 727580672  
> total extent tree bytes: 483426304  
> btree space waste bytes: 1194373662  
> file data blocks allocated: 12133646495744  
> referenced 12155707805696  
> 
> real    100m12.252s  
> user    0m33.771s  
> sys     1m11.220s 
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
> Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=aM1dKUolLxTtIO-Lzj78H4ut4SBtL_PddTteGDuBebc&s=vl4rfHfvogAgd7IHj7J1ZX4Joo9Rwj87HHq-BoldS8k&e=                          | PGP 1024R/763BE901
