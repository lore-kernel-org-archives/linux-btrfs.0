From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 2/2] add detailed help messages to btrfs command
Date: Mon, 11 Jul 2011 20:38:04 +0200
Message-ID: <4E1B430C.3020008@libero.it>
References: <201101231339.36599.kario@wit.edu.pl> <201101231342.43637.kario@wit.edu.pl> <4E1B1309.2080408@jan-o-sch.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hubert Kario <kario@wit.edu.pl>, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo@carfax.org.uk>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1B1309.2080408@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all.

what about generating the man page on the basis of the btrfs help
detailed messages ?

My idea is the following:
before the function source associated to the command we can put a
comment with a detailed help. The comment may be:

[...]
/*** man:btrfs subvolume create
 *
 *  btrfs subvolume create <path>
 *     create a new subvolume
 *
 *  The command [b]btrfs subvolume create[b] is used.....
 *
 ***/

void do_create_subvolume(int argc, char **argv)
{
[...]

A script extracts from the comment in the source both:
- the text for the man page
- the text for the detailed help.

So we can reach the following goals:
- the help is linked to the code
- is less likely to forget to update the message
- the man page, the helps are always aligned

BR
G.Baroncelli



On 07/11/2011 05:13 PM, Jan Schmidt wrote:
> Hi Hubert,
> 
> I have to admit I did not recognize this patch but now Hugo is forcing
> me to use the "detailed help messages" and I've got an improvement to
> suggest:
> 
> On 23.01.2011 13:42, Hubert Kario wrote:
>> extend the
>>
>>         btrfs <cmd> --help
>>
>> command to print detailed help message if available but fallback to
>> basic help message if detailed is unavailable
>>
>> add detailed help message for 'filesystem defragment' command
>>
>> little tweaks in comments
>>
>> Signed-off-by: Hubert Kario <kario@wit.edu.pl>
>> ---
>>  btrfs.c |  101 ++++++++++++++++++++++++++++++++++++++++++--------------------
>>  1 files changed, 68 insertions(+), 33 deletions(-)
>>
>> diff --git a/btrfs.c b/btrfs.c
>> index b84607a..bd6f6f8 100644
>> --- a/btrfs.c
>> +++ b/btrfs.c
>> @@ -23,6 +23,9 @@
>>  #include "btrfs_cmds.h"
>>  #include "version.h"
>>  
>> +#define BASIC_HELP 0
>> +#define ADVANCED_HELP 1
>> +
>>  typedef int (*CommandFunction)(int argc, char **argv);
>>  
>>  struct Command {
>> @@ -31,8 +34,10 @@ struct Command {
>>  				   if >= 0, number of arguments,
>>  				   if < 0, _minimum_ number of arguments */
>>  	char	*verb;		/* verb */
>> -	char	*help;		/* help lines; form the 2nd onward they are
>> -				   indented */
>> +	char	*help;		/* help lines; from the 2nd line onward they 
>> +                                   are automatically indented */
>> +        char    *adv_help;      /* advanced help message; from the 2nd line 
>> +                                   onward they are automatically indented */
>>  	/* the following fields are run-time filled by the program */
>>  	char	**cmds;		/* array of subcommands */
>> @@ -47,73 +52,96 @@ static struct Command commands[] = {
>>  	{ do_clone, 2,
>>  	  "subvolume snapshot", "<source> [<dest>/]<name>\n"
>>  		"Create a writable snapshot of the subvolume <source> with\n"
>> -		"the name <name> in the <dest> directory."
>> +		"the name <name> in the <dest> directory.",
>> +          NULL
>>  	},
>>  	{ do_delete_subvolume, 1,
>>  	  "subvolume delete", "<subvolume>\n"
>> -		"Delete the subvolume <subvolume>."
>> +		"Delete the subvolume <subvolume>.",
>> +          NULL
>>  	},
>>  	{ do_create_subvol, 1,
>>  	  "subvolume create", "[<dest>/]<name>\n"
>>  		"Create a subvolume in <dest> (or the current directory if\n"
>> -		"not passed)."
>> +		"not passed).",
>> +          NULL
>>  	},
>>  	{ do_subvol_list, 1, "subvolume list", "<path>\n"
>> -		"List the snapshot/subvolume of a filesystem."
>> +		"List the snapshot/subvolume of a filesystem.",
>> +          NULL
>>  	},
>>  	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
>> -		"List the recently modified files in a filesystem."
>> +		"List the recently modified files in a filesystem.",
>> +          NULL
>>  	},
>>  	{ do_defrag, -1,
>>  	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
>> -		"Defragment a file or a directory."
>> +		"Defragment a file or a directory.",
>> +          "[-vcf] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
>> +          "Defragment file data or directory metadata.\n"
>> +                "-v         be verbose\n"
>> +                "-c         compress the file while defragmenting\n"
>> +                "-f         flush data to disk immediately after defragmenting\n"
>> +                "-s start   defragment only from byte onward\n"
>> +                "-l len     defragment only up to len bytes\n"
>> +                "-t size    minimal size of file to be considered for defragmenting\n"
> 
> Lots of too long lines.
> 
> I don't like to repeat the synopsis passage. How about adding the
> general ->help when printing ->adv_help as well? This reduces the need
> of duplication.
> 
> To prove my point, looking at the current version in Hugo's integration
> branch, your two synopsis lines already got inconsistent regarding the
> -c option :-)
> 
>>  	},
>>  	{ do_set_default_subvol, 2,
>>  	  "subvolume set-default", "<id> <path>\n"
>>  		"Set the subvolume of the filesystem <path> which will be mounted\n"
>> -		"as default."
>> +		"as default.",
>> +          NULL
>>  	},
>>  	{ do_fssync, 1,
>>  	  "filesystem sync", "<path>\n"
>> -		"Force a sync on the filesystem <path>."
>> +		"Force a sync on the filesystem <path>.",
>> +          NULL
>>  	},
>>  	{ do_resize, 2,
>>  	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
>>  		"Resize the file system. If 'max' is passed, the filesystem\n"
>> -		"will occupe all available space on the device."
>> +		"will occupe all available space on the device.",
>> +          NULL
>>  	},
>>  	{ do_show_filesystem, 999,
>>  	  "filesystem show", "[<uuid>|<label>]\n"
>>  		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
>> -		"is passed, info of all the btrfs filesystem are shown."
>> +		"is passed, info of all the btrfs filesystem are shown.",
>> +          NULL
>>  	},
>>  	{ do_df_filesystem, 1,
>>  	  "filesystem df", "<path>\n"
>> -		"Show space usage information for a mount point\n."
>> +		"Show space usage information for a mount point.",
>> +          NULL
>>  	},
>>  	{ do_balance, 1,
>>  	  "filesystem balance", "<path>\n"
>> -		"Balance the chunks across the device."
>> +		"Balance the chunks across the device.",
>> +          NULL
>>  	},
>>  	{ do_scan,
>>  	  999, "device scan", "[<device> [<device>..]\n"
>>  		"Scan all device for or the passed device for a btrfs\n"
>> -		"filesystem."
>> +		"filesystem.",
>> +          NULL
>>  	},
>>  	{ do_add_volume, -2,
>>  	  "device add", "<dev> [<dev>..] <path>\n"
>> -		"Add a device to a filesystem."
>> +		"Add a device to a filesystem.",
>> +          NULL
>>  	},
>>  	{ do_remove_volume, -2,
>>  	  "device delete", "<dev> [<dev>..] <path>\n"
>> -		"Remove a device from a filesystem."
>> +		"Remove a device from a filesystem.",
>> +          NULL
>>  	},
>>  	/* coming soon
>>  	{ 2, "filesystem label", "<label> <path>\n"
>> -		"Set the label of a filesystem"
>> +		"Set the label of a filesystem",
>> +          NULL
>>  	}
>>  	*/
>> -	{ 0, 0 , 0 }
>> +	{ 0, 0, 0, 0 }
>>  };
>>  
>>  static char *get_prgname(char *programname)
>> @@ -128,17 +156,25 @@ static char *get_prgname(char *programname)
>>  	return np;
>>  }
>>  
>> -static void print_help(char *programname, struct Command *cmd)
>> +static void print_help(char *programname, struct Command *cmd, int helptype)
>>  {
>>  	char	*pc;
>>  
>>  	printf("\t%s %s ", programname, cmd->verb );
>>  
>> -	for(pc = cmd->help; *pc; pc++){
>> -		putchar(*pc);
>> -		if(*pc == '\n')
>> -			printf("\t\t");
>> -	}
>> +        if (helptype == ADVANCED_HELP && cmd->adv_help)
> 
> As mentioned above, I'd like to have ->help printed here, above. You can
> make the loop in the else branch below unconditional and just put the
> advanced part inside the if.
> 
>> +                for(pc = cmd->adv_help; *pc; pc++){
>> +                        putchar(*pc);
>> +                        if(*pc == '\n')
>> +                                printf("\t\t");
>> +                }
>> +        else
>> +	        for(pc = cmd->help; *pc; pc++){
>> +		        putchar(*pc);
>> +		        if(*pc == '\n')
>> +			        printf("\t\t");
>> +	        }
>> +
>>  	putchar('\n');
>>  }
>>  
>> @@ -148,10 +184,10 @@ static void help(char *np)
>>  
>>  	printf("Usage:\n");
>>  	for( cp = commands; cp->verb; cp++ )
>> -		print_help(np, cp);
>> +		print_help(np, cp, BASIC_HELP);
>>  
>>  	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
>                             ^^^^^^^^^
> You did not change this, but as we are here, ...
> 
>> -	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command or\n\t\t"
>> +	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command or"
>                              ^^^^^^^
> .. why not extending the general rule so that help messages will be
> printed with --help and -h?
> 
>>              "subset of commands.\n",np);
>>  	printf("\n%s\n", BTRFS_BUILD_VERSION);
>>  }
>> @@ -257,15 +293,14 @@ static int prepare_args(int *ac, char ***av, char *prgname, struct Command *cmd
>>  
>>  
>>  /*
>> -
>> -	This function perform the following jobs:
>> +	This function performs the following jobs:
>>  	- show the help if '--help' or 'help' or '-h' are passed
>>  	- verify that a command is not ambiguous, otherwise show which
>>  	  part of the command is ambiguous
>> -	- if after a (even partial) command there is '--help' show the help
>> +	- if after a (even partial) command there is '--help' show detailed help
>>  	  for all the matching commands
>> -	- if the command doesn't' match show an error
>> -	- finally, if a command match, they return which command is matched and
>> +	- if the command doesn't match show an error
>> +	- finally, if a command matches, they return which command matched and
>>  	  the arguments
>>  
>>  	The function return 0 in case of help is requested; <0 in case
>> @@ -319,7 +354,7 @@ static int parse_args(int argc, char **argv,
>>  		if(argc>i+1 && !strcmp(argv[i+1],"--help")){
>>  			if(!helprequested)
>>  				printf("Usage:\n");
>> -			print_help(prgname, cp);
>> +			print_help(prgname, cp, ADVANCED_HELP);
>>  			helprequested=1;
>>  			continue;
>>  		}
> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

