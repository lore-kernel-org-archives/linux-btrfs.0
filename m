From: Chuck Burns <chuck@thesouthernlibertarian.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Tue, 3 May 2011 19:25:36 -0500
Message-ID: <201105031925.36714.chuck@thesouthernlibertarian.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105031802.43215.chuck@thesouthernlibertarian.com> <201105031712.43222.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105031712.43222.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, May 03, 2011 07:12:42 PM CACook@quantum-sci.com wrote:
> I know what the error says;  we've established that / is in fact mounted. 
> The system boots and runs, but grub doesn't understand it.  My only answer
> is that grub-probe does not understand BTRFS.
> 
> The question is what to do about this.  I have three major systems
> committed to this filesystem.  Can you not see how this is an emergency?
> 
> How is re-reading the error supposed to help anything?  Or was your
> intention to help?

You should upgrade grub, manually (ie, do not use the package manager) and you 
need to contact your distribution to find out how to do that.

-- 
Chuck Burns
The Southern Libertarian - owner
http://thesouthernlibertarian.com/
