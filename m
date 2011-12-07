From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: System Storage Manager
Date: Wed, 7 Dec 2011 12:17:34 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112071208190.15332@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1112071055270.4205@dhcp-27-109.brq.redhat.com> <4EDF4672.9080705@draigBrady.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-927029420-1323256658=:15332"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-lvm@redhat.com,
	linux-btrfs@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>
To: =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EDF4672.9080705@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-927029420-1323256658=:15332
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 7 Dec 2011, Pádraig Brady wrote:

> On 12/07/2011 10:20 AM, Lukas Czerner wrote:
> > Hello everyone,
> > 
> > I would like to introduce to you a new tool called System Storage
> > Manager (ssm). It is supposed to provide easy to use command line
> > interface to manage your storage using various technologies like
> > lvm, btrfs, encrypted volumes and possibly more.
> > 
> > Background
> > ----------
> > 
> > In more sophisticated enterprise storage environments, management with
> > Device Mapper (dm), Logical Volume Manager (LVM), or Multiple Devices
> > (md) is becoming increasingly more difficult. With file systems added
> > to the mix, the number of tools needed to configure and manage storage
> > has grown so large that it is simply not user friendly. With so many
> > options for a system administrator to consider, the opportunity for
> > errors and problems is large.
> 
> This seems like a worthwhile project given the overlap
> in functionality from the various commands.
> It echoes some of the functionality provided by libguestfs
> for VM images I think.
> 
> > The btrfs administration tools have shown us that storage management can
> > be simplified, and we are working to bring that ease of use to Linux
> > filesystems in general.
> > 
> > 
> > You can also find some more information in my presentation from LinuxCon
> > Prague this year:
> > 
> > http://people.redhat.com/lczerner/files/lczerner_fsm.pdf
> 
> This had the name 'fsm'.

Yes I had to change it, since fsm implies file system, but it is not
only about file systems.

> I do think 'ssm' is better, however I would drop the '.py' from

Already done. But I can see that it is still present in the README file.
Will fix it, tanks.

> the command name. This is incidental and restrictive going forward.
> Note I checked the debian and freebsd man pages and 'ssm' is available.

I could not find it on http://manpages.debian.net/cgi-bin/man.cgi but I
know there is a project called ssm:

ssm.i686 : Macromolecular coordinate superposition library

but my project is called System Storage Manager and ssm is just the
executable. I could not find any binary with the same name (within
Fedora), not sure if that will be a problem...

> 
> > The code is still under development and no release has been made yet, but
> > I would like to share with you what I have done so far, since the
> > progress has been a bit slower than I have previously expected. The
> > project lives on the sf.net :
> > 
> > https://sourceforge.net/projects/storagemanager/
> 
> This is a much cleaner landing page:
> http://sourceforge.net/p/storagemanager/home/Home/
> 
> cheers,
> Pádraig.
> 

Thanks for comments!
-Lukas
--8323328-927029420-1323256658=:15332--
